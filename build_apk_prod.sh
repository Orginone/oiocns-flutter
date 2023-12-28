#fvm flutter build apk -t lib/main.dart --flavor stage  --target-platform android-arm,android-arm64 \
if command -v fvm >/dev/null 2>&1; then
  fvm flutter build apk -t lib/main_prod.dart --target-platform android-arm,android-arm64
else
  flutter build apk -t lib/main_prod.dart --target-platform android-arm,android-arm64
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

# mv "app-prod-release.apk" "oiocns-prod.apk"

if command -v start >/dev/null 2>&1; then
  start .
elif command -v open >/dev/null 2>&1; then
  open .
fi
