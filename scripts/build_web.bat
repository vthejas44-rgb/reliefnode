@echo off
echo =============================================
echo   ReliefNode: Building Static Web Deployments
echo =============================================

if not exist "public\volunteer" mkdir "public\volunteer"

echo [1/3] Preparing Victim Captive Portal...
copy /Y frontend\index.html public\index.html >nul

echo [2/3] Compiling Flutter Volunteer App...
cd mobile_app
call flutter pub get
call flutter build web --release --base-href "/volunteer/"
cd ..

echo [3/3] Copying Flutter web bundle to public/volunteer/...
xcopy /E /I /Y mobile_app\build\web public\volunteer >nul

echo =============================================
echo Build complete! Dual deployment ready in \public
echo   - Victim Portal:   /
echo   - Volunteer Mule:  /volunteer/
echo =============================================
