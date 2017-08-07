#!/bin/sh
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security import ./scripts/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/ios-dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $P12_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles
