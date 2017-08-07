#!/bin/sh
mkdir bin
xcodebuild archive -workspace BLESensorApp.xcworkspace -scheme BLESensorApp -archivePath bin/app.xcarchive -destination generic/platform=iOS ONLY_ARCHIVE_ARCH=NO 
xcodebuild -exportArchive -archivePath bin/app.xcarchive -exportPath bin/ -exportOptionsPlist scripts/export.plist
