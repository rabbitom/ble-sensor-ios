//
//  ViewController.m
//  BLESensorTest
//
//  Created by 郝建林 on 2016/11/3.
//  Copyright © 2016年 CoolTools Software Development Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import <BLESensorSDK/BLESensorSDK.h>

@interface ViewController ()
{
    BLEDevicesManager *devicesManager;
    NSMutableArray *devices;
    BLEIoTSensor *sensor;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 获取设备管理器
    devicesManager = [BLEDevicesManager sharedInstance];
    // 加载设备类型定义，只能调用一次
    [BLEIoTSensor setupDevicesManager:devicesManager];
    
    // 初始化设备数组
    devices = [NSMutableArray array];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundBLEDevice:) name:@"BLEDevice.FoundDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Connected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Disconnected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceReady:) name:@"BLEDevice.Ready" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceValueChanged:) name:@"BLEDevice.ValueChanged" object:nil];
    
    
}
- (IBAction)Search:(id)sender {
    // 开始搜索设备
    [devicesManager searchDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 通知消息

// 搜索到设备
- (void)onFoundBLEDevice: (NSNotification*)notification {
    [devices addObject:notification.object];
    [devicesManager stopSearching];
    sensor = devices[0];
    [sensor connect];
}

// 设备连接上或断开连接
- (void)onDeviceConnectionStatusChanged: (NSNotification*)notification {
}

// 设备就绪（在连接上以后完成了必要的初始化）
- (void)onDeviceReady: (NSNotification*)notification {
    if(notification.object == sensor) {
        for(NSString *featureName in sensor.features.allKeys) {
            [sensor startReceiveData:featureName];
        }
    }
}

// 收到数据
- (void)onDeviceValueChanged: (NSNotification*)notification {
    NSString *key = notification.userInfo[@"key"];
    NSObject *value = notification.userInfo[@"value"];
    if(value.class == [SensorFeature class]) {
        SensorFeature *feature = (SensorFeature*)value;
        NSLog(@"%@ = %@", key, feature.valueString);
    }
}

@end
