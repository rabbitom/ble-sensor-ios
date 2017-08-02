//
//  DeviceFeaturesViewController.m
//  BLESensorApp
//
//  Created by 郝建林 on 2016/11/3.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "DeviceFeaturesViewController.h"
#import <BLESensorSDK/BLESensorSDK.h>
#import "DeviceDataViewController.h"
#import "Device3DViewController.h"

@interface DeviceFeaturesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BLEIoTSensor *sensor;
    NSMutableDictionary *featureSwitches;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectBtn;
@end

@implementation DeviceFeaturesViewController

- (BLEDevice*)device {
    return sensor;
}

- (void)setDevice:(BLEDevice *)device {
    if(device.class == BLEIoTSensor.class) {
        sensor = (BLEIoTSensor*)device;
        if(self.device != nil) {
            if(!self.device.isConnected) {
                [self.device connect];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Connected" object:self.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceConnectionStatusChanged:) name:@"BLEDevice.Disconnected" object:self.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceReady:) name:@"BLEDevice.Ready" object:self.device];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceValueChanged:) name:@"BLEDevice.ValueChanged" object:self.device];
    self.navigationItem.title = [self.device deviceNameByDefault:@"Unnamed Device"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Connect", @"InfoPlist",nil) style:UIBarButtonItemStylePlain target:self action:@selector(toggleConnect:)];
    self.connectBtn = self.navigationItem.rightBarButtonItem;
    [self updateConnectBtn];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUInteger index = 0;
    for(SensorFeature *feature in sensor.features.allValues) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        UISwitch *featureSwitch = [cell viewWithTag:3];
        featureSwitch.on = [sensor isReceivingData:feature.name];
        index++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDeviceReady: (NSNotification*)notification {
    if(notification.object == self.device)
        [self.tableView reloadData];
}

- (void)onDeviceConnectionStatusChanged: (NSNotification*)notification {
    [self updateConnectBtn];
}

- (void)onDeviceValueChanged: (NSNotification*)notification {
    NSString *key = notification.userInfo[@"key"];
    SensorFeature *feature = sensor.features[key];
    if(feature != nil) {
        NSUInteger index = [sensor.features.allValues indexOfObject:feature];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        UILabel *valueLabel = [cell viewWithTag:2];
        valueLabel.text = feature.valueString;
    }
}

- (void)updateConnectBtn {
    self.connectBtn.title = self.device.isConnected ? NSLocalizedStringFromTable(@"Disconnect", @"InfoPlist",nil) : NSLocalizedStringFromTable(@"Connect", @"InfoPlist",nil);
}

- (void)toggleConnect:(UIButton *)sender {
    if(self.device.isConnected)
        [self.device disconnect];
    else
        [self.device connect];
}

- (void)onFeatureSwitch: (UISwitch*)featureSwitch {
    for(NSString *featureName in featureSwitches.allKeys) {
        if(featureSwitches[featureName] == featureSwitch) {
            if(featureSwitch.isOn)
                [sensor startReceiveData:featureName];
            else
                [sensor stopReceiveData:featureName];
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sensor.features.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feature" forIndexPath:indexPath];
    
    UILabel *name = [cell viewWithTag:1];
    UILabel *value = [cell viewWithTag:2];
    UISwitch *featureSwitch = [cell viewWithTag:3];
    
    SensorFeature *feature = sensor.features.allValues[indexPath.row];
   
    name.text = STRING_BY_DEFAULT(NSLocalizedStringFromTable(feature.name, @"InfoPlist",nil), @"Unknown Feature");
    value.text = feature.valueString;
    featureSwitch.on = [sensor isReceivingData: feature.name];
    if(featureSwitches == nil)
        featureSwitches = [NSMutableDictionary dictionary];
    [featureSwitches setObject:featureSwitch forKey:feature.name];
    [featureSwitch addTarget:self action:@selector(onFeatureSwitch:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SensorFeature *feature = sensor.features.allValues[indexPath.row];
    if([feature.name isEqualToString:@"SFL"])
        [self performSegueWithIdentifier:@"ShowGLView" sender:feature.name];
    else
        [self performSegueWithIdentifier:@"ShowDataView" sender:feature.name];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"ShowDataView"]) {
        DeviceDataViewController *deviceDataViewController = segue.destinationViewController;
        deviceDataViewController.propertyName = sender;
        deviceDataViewController.device = self.device;
    }
    else {
        id<DeviceDetailController> vc = segue.destinationViewController;
        vc.device = self.device;
    }
}


@end
