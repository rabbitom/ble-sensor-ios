#!/bin/sh
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security import profiles/ios-dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $P12_PASSWORD -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple: -s -k travis ios-build.keychain
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp profiles/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles
