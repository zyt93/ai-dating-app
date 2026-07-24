# 在有网机器上构建 APK 的完整指南

## 方案一：腾讯云镜像（推荐，速度最快）

### 1. 安装 Flutter SDK（用腾讯云 Git 代理克隆）

```powershell
# 设置 Git 代理（腾讯云 CDN 加速 GitHub）
git config --global url."https://ghproxy.com/".insteadOf "https://github.com/"

# 克隆 Flutter（腾讯云代理，~3分钟）
git clone https://ghproxy.com/https://github.com/flutter/flutter.git D:\flutter --depth 1

# 或用 ghproxy.net
git config --global url."https://ghproxy.net/".insteadOf "https://github.com/"
git clone https://ghproxy.net/https://github.com/flutter/flutter.git D:\flutter --depth 1
```

### 2. 国内镜像配置

```powershell
# PowerShell 永久环境变量（需要管理员权限）
[System.Environment]::SetEnvironmentVariable(
    "PUB_HOSTED_URL", "https://pub.flutter-io.cn", "User")
[System.Environment]::SetEnvironmentVariable(
    "FLUTTER_STORAGE_BASE_URL", "https://storage.flutter-io.cn", "User")
[System.Environment]::SetEnvironmentVariable(
    "ANDROID_HOME", "$env:USERPROFILE\AppData\Local\Android\Sdk", "User")
[System.Environment]::SetEnvironmentVariable(
    "PATH", "D:\flutter\bin;$env:PATH", "User")
```

### 3. 初始化 Flutter

```powershell
# 新开 PowerShell 窗口
flutter --version

# 或直接指定镜像
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
D:\flutter\bin\flutter.bat --version
```

---

## 方案二：Flutter CN 官方（需手动下载）

1. 访问 https://flutter.cn/docs/get-started/install/windows
2. 下载 `flutter_windows_x.zip`（约 500MB）
3. 解压到 `D:\flutter`
4. 设置环境变量 `PATH=D:\flutter\bin`
5. 国内镜像设置同上

---

## Android SDK 安装（国内镜像）

### 腾讯云镜像安装

```powershell
$sdkRoot = "$env:USERPROFILE\AppData\Local\Android\Sdk"

# 1. 下载 cmdline-tools
Invoke-WebRequest -Uri "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip" `
    -OutFile "$env:TEMP\cmdline-tools.zip"

# 2. 解压到正确位置
Expand-Archive -Path "$env:TEMP\cmdline-tools.zip" -DestinationPath "$sdkRoot\temp"
New-Item -ItemType Directory -Path "$sdkRoot\cmdline-tools\latest" -Force | Out-Null
Move-Item -Path "$sdkRoot\temp\cmdline-tools\*" -Destination "$sdkRoot\cmdline-tools\latest\" -Force
Remove-Item "$sdkRoot\temp" -Recurse -Force

# 3. 腾讯云镜像安装 platforms + build-tools
$sdkManager = "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat"

& $sdkManager --sdk_root=$sdkRoot `
    "platforms;android-34" `
    "build-tools;34.0.0" `
    "platform-tools"

# 4. 接受许可
& $sdkManager --sdk_root=$sdkRoot --licenses
# 输入 y 接受所有许可
```

### 或使用清华 TUNA 镜像

```powershell
$sdkManager = "$sdkRoot\cmdline-tools\latest\bin\sdkmanager.bat"

# 设置镜像
& $sdkManager --sdk_root=$sdkRoot `
    --channel=0 `
    "https://mirrors.tuna.tsinghua.edu.cn/android/repository/repository2-3.xml"

# 然后安装
& $sdkManager --sdk_root=$sdkRoot `
    "platforms;android-34" `
    "build-tools;34.0.0" `
    "platform-tools"
```

---

## 构建 APK

```powershell
cd ai_dating_app

# 获取依赖
flutter pub get

# 构建 release 版本
flutter build apk --release

# 或 debug 版本（更快）
flutter build apk --debug
```

输出文件：`build/app/outputs/flutter-apk/app-release.apk`

---

## 常见问题

### Q: flutter doctor 报 Android license 错误

```bash
flutter doctor --android-licenses
# 或
yes | sdkmanager.bat --sdk_root=%ANDROID_HOME% --licenses
```

### Q: Gradle 下载慢

编辑 `android/gradle/wrapper/gradle-wrapper.properties`，修改 distributionUrl 为腾讯云镜像：

```
distributionUrl=https://mirrors.cloud.tencent.com/gradle/gradle-8.4-all.zip
```

### Q: 国内 pub.dev 拉取依赖慢

```bash
flutter pub get --pub-referrer="https://pub.flutter-io.cn"
# 或设置环境变量
set PUB_HOSTED_URL=https://pub.flutter-io.cn
flutter pub get
```

### Q: 下载 Google Fonts 失败（Flutter 工程无外网）

编辑 `pubspec.yaml`，注释掉 `google_fonts` 依赖：

```yaml
# 注释这行：
# google_fonts: ^6.1.0
```

重新 `flutter pub get`

### Q: Flutter SDK 下载太慢

使用 GitHub 代理：

```bash
git config --global url."https://ghproxy.com/".insteadOf "https://github.com/"
git config --global url."https://ghproxy.net/".insteadOf "https://github.com/"
```
