#fvm flutter build apk -t lib/main.dart --flavor stage  --target-platform android-arm,android-arm64 \
if command -v fvm >/dev/null 2>&1; then
  fvm flutter build apk -t lib/main_dev.dart --target-platform android-arm,android-arm64
else
  flutter build apk -t lib/main_dev.dart --target-platform android-arm,android-arm64
fi
###
 # @Descripttion: 
 # @version: 
 # @Author: congsir
 # @Date: 2022-11-14 18:19:43
 # @LastEditors: 
 # @LastEditTime: 2022-11-24 09:56:33
### 
#  --obfuscate --split-debug-info=build/app/outputs/dist/

cd build/app/outputs/flutter-apk/

mv "app-dev-release.apk" "oiocns-dev.apk"

if command -v start >/dev/null 2>&1; then
  start .
fi
