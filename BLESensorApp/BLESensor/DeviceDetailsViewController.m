//
//  DeviceDetailsViewController.m
//  BLESensor
//
//  Created by 郝建林 on 16/8/24.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "DeviceDetailsViewController.h"

@interface DeviceDetailsViewController()
{
    BLEDevice *_device;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectBtn;

@end

@implementation DeviceDetailsViewController

- (BLEDevice*)device {
    return _device;
}

- (void)setDevice:(BLEDevice *)device
{
    DLog("");
    _device = device;
    if(self.device != nil) {
        if(!self.device.isConnected) {
            [self.device connect];
        }
        for(id<DeviceDetailController> vc in self.viewControllers) {
            vc.device = self.device;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Connected" object:self.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Disconnected" object:self.device];
    
    self.navigationItem.title = [self.device deviceNameByDefault:@"Unnamed Device"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Connect" style:UIBarButtonItemStylePlain target:self action:@selector(toggleConnect:)];
    self.connectBtn = self.navigationItem.rightBarButtonItem;
    [self updateConnectBtn];
}


- (void)onDeviceConnectionStatusChanged: (NSNotification*)notification {
    [self updateConnectBtn];
}

- (void)updateConnectBtn {
    self.connectBtn.title = self.device.isConnected ? @"Disconnect" : @"Connect";
}

- (IBAction)toggleConnect:(id)sender {
    if(self.device.isConnected)
        [self.device disconnect];
    else
        [self.device connect];
}

@end
