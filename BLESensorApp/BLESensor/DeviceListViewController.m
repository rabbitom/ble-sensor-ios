//
//  DeviceListViewController.m
//  BLESensor
//
//  Created by 郝建林 on 16/8/22.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceFeaturesViewController.h"
#import <BLESensorSDK/BLESensorSDK.h>
#import "DeviceDataViewController.h"

#define SEARCH_DEVICES_TIME 5.0

@interface DeviceListViewController ()
{
    NSMutableArray *devices;
    BLEDevicesManager *devicesManager;
    NSTimer *searchTimer;
    UIAlertView *searchAlert;
    UIImage *deviceConnectionStatusImage;
}

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if(devices == nil) {
        devices = [NSMutableArray array];
        devicesManager = [BLEDevicesManager sharedInstance];
        [BLEIoTSensor setupDevicesManager: devicesManager];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundBLEDevice:) name:@"BLEDevice.FoundDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Connected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Disconnected" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scan:(id)sender {
    [devicesManager searchDevices];
    NSMutableArray *connectedDevices = [NSMutableArray array];
    for(BLEDevice *device in devices) {
        if(device.isConnected)
            [connectedDevices addObject:device];
    }
    [devices removeAllObjects];
    [devices addObjectsFromArray:connectedDevices];
    [self.tableView reloadData];
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:SEARCH_DEVICES_TIME target:self selector:@selector(onSearchTimeout:) userInfo:nil repeats:NO];
    searchAlert = [[UIAlertView alloc]
                   initWithTitle:NSLocalizedStringFromTable(@"Scan", @"InfoPlist",nil)
                   message:NSLocalizedStringFromTable(@"Scanning for devices...",@"InfoPlist",nil)
                   delegate:self
                   cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel",@"InfoPlist",nil)
                   otherButtonTitles:nil];
    [searchAlert show];
}

- (void)onSearchTimeout: (NSTimer*)timer {
    [devicesManager stopSearching];
    [searchAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == searchAlert) {
        if(buttonIndex == alertView.cancelButtonIndex) {
            [devicesManager stopSearching];
            [searchTimer invalidate];
        }
    }
}

#pragma mark - notification observer
- (void)onFoundBLEDevice: (NSNotification*)notification {
    [devices addObject:notification.object];
    [self.tableView reloadData];
}

- (void)onDeviceConnectionStatusChanged: (NSNotification*)notification {
    id device = notification.object;
    NSUInteger index = [devices indexOfObject:device];
    if(index != NSNotFound) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self updateCell:cell ofDevice:device];
    }
}

#pragma mark - Table view data source
- (void)updateCell: (UIView*)cell ofDevice: (BLEDevice*)device {
    UILabel *deviceName = [cell viewWithTag:1];
    UILabel *deviceDesc = [cell viewWithTag:2];
    UILabel *deviceRSSI = [cell viewWithTag:3];
    UIImageView *connectionStatus = [cell viewWithTag:4];
    if(deviceConnectionStatusImage == nil)
        deviceConnectionStatusImage =[connectionStatus.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    connectionStatus.image = deviceConnectionStatusImage;
    
    deviceName.text = [device deviceNameByDefault: @"<Unnamed>"];
    deviceDesc.text = device.deviceKey;
    deviceRSSI.text = [NSString stringWithFormat:@"%@: %d", NSLocalizedStringFromTable(@"RSSI", @"InfoPlist",nil),device.rssi];
    connectionStatus.hidden = !device.isConnected;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceItem" forIndexPath:indexPath];
    
    BLEDevice *device = devices[indexPath.row];
    [self updateCell:cell ofDevice:device];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDeviceDetails" sender:devices[indexPath.row]];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"ShowDeviceDetails"]) {
//        DeviceFeaturesViewController *vc = segue.destinationViewController;
//        UITableViewCell *cell = sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        vc.device = devices[indexPath.row];
        DeviceDataViewController *DeviceDataVc = segue.destinationViewController;
//        UITableViewCell *cell = sender;x
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DeviceDataVc.device = sender;
    }
}

@end
