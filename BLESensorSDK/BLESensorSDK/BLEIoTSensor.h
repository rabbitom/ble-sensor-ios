//
//  BLEIoTSensor.h
//  BLESensor
//
//  Created by 郝建林 on 16/8/23.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "BLEDevice.h"
#import "BLEDevicesManager.h"

@interface BLEIoTSensor : BLEDevice

@property (readonly) NSDictionary* features;
@property (readonly) BOOL isSensorOn;

+ (void)setupDevicesManager: (BLEDevicesManager*)devicesManager;

@end
