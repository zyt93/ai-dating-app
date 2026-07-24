@echo off
chcp 65001 >nul
echo ================================================
echo   AI 相亲助手 - 一键构建脚本
echo ================================================
echo.

:: 检查 Flutter
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Flutter，请先安装 Flutter SDK
    echo 请访问: https://flutter.cn/docs/get-started/install/windows
    echo 或参考: BUILD_GUIDE.md
    pause
    exit /b 1
)

echo [OK] Flutter 已安装
flutter --version | findstr /C:"Flutter"
echo.

:: 检查 Android SDK
echo [检查] Android SDK...
if not defined ANDROID_HOME (
    echo [警告] ANDROID_HOME 未设置，尝试从默认路径检测...
    if exist "%LOCALAPPDATA%\Android\Sdk" (
        set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk
        echo [OK] 使用: %ANDROID_HOME%
    )
)
echo.

:: 获取依赖
echo [1/3] flutter pub get ...
flutter pub get
if %errorlevel% neq 0 (
    echo [错误] flutter pub get 失败
    pause
    exit /b 1
)
echo.

:: 构建 APK
echo [2/3] flutter build apk --release ...
flutter build apk --release
if %errorlevel% neq 0 (
    echo [错误] 构建失败
    pause
    exit /b 1
)
echo.

:: 完成
echo [3/3] 检查输出文件...
set APK=build\app\outputs\flutter-apk\app-release.apk
if exist "%APK%" (
    echo.
    echo ================================================
    echo   构建成功！
    echo ================================================
    echo APK 路径: %cd%\%APK%
    for %%A in ("%APK%") do echo 文件大小: %%~zA bytes ^(%%~zA / 1048576 MB^)
    echo.
    echo 安装到手机: adb install %APK%
) else (
    echo [错误] 未找到 APK 文件
    dir /s /b build\app\outputs\flutter-apk\*.apk 2>nul
)
echo.
echo 按任意键退出...
pause >nul
