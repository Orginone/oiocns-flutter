#fvm flutter build apk -t lib/main.dart --flavor stage  --target-platform android-arm,android-arm64 \
fvm flutter build apk -t lib/main.dart --target-platform android-arm,android-arm64 \
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

mv "app-release.apk" "oiocns-app.apk"

start .
