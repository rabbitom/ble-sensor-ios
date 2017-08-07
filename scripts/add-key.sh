#!/bin/sh
security create-keychain -p travis ios-build.keychain
security import ./scripts/ios-dist.p12 ~/Library/Keychains/ios-build.keychain -P $P12_PASSWORD -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles
