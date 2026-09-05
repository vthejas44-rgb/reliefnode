# Raspberry Pi Edge Node Setup Guide

Step-by-step instructions to configure a Raspberry Pi as an offline emergency Wi-Fi hub with captive portal auto-redirection.

---

## 1. Prerequisites
- Raspberry Pi (3B+, 4B, or Zero 2W) running Raspberry Pi OS Lite (64-bit).
- MicroSD card (16GB+).

---

## 2. Install Dependencies

```bash
sudo apt update
sudo apt install -y hostapd dnsmasq nginx
sudo systemctl stop hostapd dnsmasq
```

---

## 3. Configure Static IP (`/etc/dhcpcd.conf`)

Add the following to the bottom of `/etc/dhcpcd.conf`:

```conf
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
```

---

## 4. Configure DHCP & DNS Hijack (`/etc/dnsmasq.conf`)

Replace `/etc/dnsmasq.conf` with:

```conf
interface=wlan0
dhcp-range=192.168.4.10,192.168.4.200,255.255.255.0,24h
# Redirect all DNS lookups to the local portal
address=/#/192.168.4.1
```

---

## 5. Configure Wi-Fi Access Point (`/etc/hostapd/hostapd.conf`)

Create `/etc/hostapd/hostapd.conf`:

```conf
interface=wlan0
driver=nl80211
ssid=EMERGENCY-RELIEF-MESH
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
```

---

## 6. Deploy Captive Portal HTML

Copy `frontend/index.html` to `/var/www/html/index.html`:

```bash
sudo cp frontend/index.html /var/www/html/index.html
```

Configure Nginx to intercept captive portal probes (`/etc/nginx/sites-available/default`):

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    # Android & iOS captive portal redirect
    location /generate_204 { return 302 http://192.168.4.1/; }
    location /gen_204 { return 302 http://192.168.4.1/; }
    location /hotspot-detect.html { return 302 http://192.168.4.1/; }
    location /connecttest.txt { return 302 http://192.168.4.1/; }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

## 7. Start Services

```bash
sudo systemctl unmask hostapd
sudo systemctl enable hostapd dnsmasq nginx
sudo systemctl restart hostapd dnsmasq nginx
```
