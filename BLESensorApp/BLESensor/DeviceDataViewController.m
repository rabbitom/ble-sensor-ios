//
//  DeviceDataViewController.m
//  BLESensor
//
//  Created by 郝建林 on 16/8/27.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "DeviceDataViewController.h"
#import <BLESensorSDK/BLESensorSDK.h>
#import "ChartView.h"
#import "CoreData.h"

@interface DeviceDataViewController ()
{
    BLEIoTSensor *sensor;
    BOOL isRecord;
    int number;
}

@property (weak, nonatomic) IBOutlet UILabel *property;
@property (weak, nonatomic) IBOutlet UISwitch *notification;
@property (weak, nonatomic) IBOutlet UILabel *curValue;
@property (weak, nonatomic) IBOutlet UILabel *maxValue;
@property (weak, nonatomic) IBOutlet UILabel *minValue;
@property (weak, nonatomic) IBOutlet UIButton *settings;
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic,strong) NSString *currentDeviceUUID;

@property SensorFeature *feature;

@end

@implementation DeviceDataViewController

@synthesize feature;

- (BLEDevice*)device {
    return sensor;
}

- (void)setDevice:(BLEDevice *)device {
    if(device.class == BLEIoTSensor.class) {
        sensor = (BLEIoTSensor*)device;
        NSDictionary *dict = [BLEIoTSensor services];
        NSArray *uuid = [dict allKeys];
        if (uuid.count == 1) {
            _currentDeviceUUID = uuid[0];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isRecord = NO;
    number = 0;
    [self initRightButton];
    
}

-(void)initRightButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 40);
    [button setTitle:@"记录" forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)click:(UIButton *)sender
{
    if (self.notification.isOn) {
        if (sender.selected) {
            sender.selected = NO;
            [self stopTimer];
            //保存记录
        }else{
            sender.selected = YES;
            //开始记录
            _startTime = [NSDate date];
            isRecord = YES;
            number++;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stratTimer:) userInfo:nil repeats:YES];
            _dataArray = [NSMutableArray array];
        }
    }else{
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先打开通知" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [aler show];
    }
}

//开始记录
-(void)stratTimer:(NSTimer *)sender
{
    number++;
}

//结束记录并保存
-(void)stopTimer
{
    [_timer invalidate];
    isRecord = NO;
    _dataDict = [NSDictionary dictionaryWithObjects:@[_startTime,_startTime,[NSString stringWithFormat:@"%d",number],self.property.text,@"Anonymous",_currentDeviceUUID] forKeys:@[@"id",@"stratTime",@"duration",@"type",@"title",@"deviceUUID"]];
    [[CoreData shareCoreData] addCoreData:_dataDict SomeType:_dataArray];
    number = 0;
}

- (void)showValueViews: (BOOL)visible {
    for(UIView *view in @[self.property, self.notification, self.curValue, self.maxValue, self.minValue, self.settings])
        view.hidden = !visible;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(sensor.features != nil) {
        if(self.propertyName != nil)
            self.feature = sensor.features[self.propertyName];
        else if((self.feature == nil) && (sensor.features.count > 0))
            self.feature = sensor.features.allValues[0];
    }
    if(self.feature == nil) {
        self.property.text = @"No Available Sensor";
        [self showValueViews:NO];
    }
    else {
        [self showValueViews:YES];
        self.property.text = NSLocalizedStringFromTable(self.feature.name, @"InfoPlist",nil);
        self.notification.on = [self.device isReceivingData:self.feature.name];
        self.chartView.dimension = self.feature.dimension;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceValueChanged:) name:@"BLEDevice.ValueChanged" object:self.device];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDeviceValueChanged: (NSNotification*)notification {
    NSString *key = notification.userInfo[@"key"];
    if(key == nil)
        return;
    if([key isEqualToString:self.feature.name]){
        self.curValue.text = self.feature.valueString;
        [self.chartView addValues:self.feature.values];
        self.maxValue.text = [NSString stringWithFormat:@"%@ %@",
                              [self.feature valueString:
                               [NSNumber numberWithFloat:self.chartView.maxValue]],
                              self.feature.unit];
        self.minValue.text = [NSString stringWithFormat:@"%@ %@",
                              [self.feature valueString:
                               [NSNumber numberWithFloat:self.chartView.minValue]],
                              self.feature.unit];
        if (isRecord) {
            NSString *str = nil;
            for (id valuess in self.feature.values) {
                NSString *string = [NSString stringWithFormat:@"%@",valuess];
                if (str != nil) {
                    str = [NSMutableString stringWithFormat:@"%@*%@",str,string];
                }else{
                    str = string;
                }
               
            }
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_startTime,[NSDate date],[NSString stringWithFormat:@"%@*%@*%f*%f",str,self.feature.unit,self.chartView.maxValue,self.chartView.minValue]] forKeys:@[@"id",@"time",@"value"]];
            [_dataArray addObject:dic];
        }
    }
}

- (IBAction)toggleNotification:(id)sender {
    if(self.notification.isOn)
        [self.device startReceiveData:self.feature.name];
    else
        [self.device stopReceiveData:self.feature.name];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"Show3DView"]) {
        id<DeviceDetailController> vc = (id<DeviceDetailController>)segue.destinationViewController;
        [vc setDevice:self.device];
    }
}


@end
