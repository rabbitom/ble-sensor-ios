//
//  BLEDevicesManager.h
//  BLESensor
//
//  Created by 郝建林 on 16/8/16.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDevicesManager : NSObject <CBCentralManagerDelegate>

+ (instancetype)sharedInstance;
+ (CBCentralManager*)central;

- (void)addDeviceClass: (Class)deviceClass byMainService: (CBUUID*)serviceUUID;

- (void)loadDevices: (NSString*)filePath;

- (void)searchDevices;
- (void)stopSearching;
//- (NSArray*)devicesOfClass: (NSString*)className sortBy: (NSString*)key max: (int)count;

- (id)findDevice: (NSUUID*)deviceId;

@end
