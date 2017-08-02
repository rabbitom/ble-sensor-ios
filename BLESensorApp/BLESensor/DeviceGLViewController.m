//
//  DeviceGLViewController.m
//  BLESensorApp
//
//  Created by 郝建林 on 2017/4/5.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "DeviceGLViewController.h"
#import "GLModelView.h"

@interface DeviceGLViewController ()
{
    BLEIoTSensor *sensor;
    SensorFeature *sfl;
}
@property (weak, nonatomic) IBOutlet GLModelView *modelView;
@end

@implementation DeviceGLViewController

@synthesize modelView;

- (BLEDevice*)device {
    return sensor;
}

- (void)setDevice:(BLEDevice *)device {
    if(device.class == BLEIoTSensor.class) {
        sensor = (BLEIoTSensor*)device;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.modelView.backgroundColor = [UIColor colorWithRed:0.88 green:0.93 blue:0.96 alpha:1];
    self.modelView.modelTransform = CATransform3DMakeScale(1, -1, 1);
    self.modelView.fov = -1.0f;
    
    self.modelView.texture = [GLImage imageNamed:@"pattern-4.png"];
    self.modelView.blendColor = [UIColor whiteColor];
    self.modelView.model = [GLModel modelWithContentsOfFile:@"Yunjia"];
    
    GLLight *light = [[GLLight alloc] init];
    light.transform = CATransform3DMakeTranslation(0.0f, 0.0f, -10.0f);
    light.ambientColor = [UIColor colorWithWhite:0.50f alpha:1.0f];
    self.modelView.lights = @[light];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(sensor.features != nil) {
        sfl = sensor.features[@"SFL"];
        if(![sensor isReceivingData:@"SFL"])
            [sensor startReceiveData:@"SFL"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceValueChanged:) name:@"BLEDevice.ValueChanged" object:self.device];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onDeviceValueChanged: (NSNotification*)notification {
    NSString *key = notification.userInfo[@"key"];
    if(key == nil)
        return;
    if([key isEqualToString:sfl.name]) {
        float qw = [(NSNumber*)sfl.values[0] floatValue];
        float qx = [(NSNumber*)sfl.values[1] floatValue];
        float qy = [(NSNumber*)sfl.values[2] floatValue];
        float qz = [(NSNumber*)sfl.values[3] floatValue];
        
        // convert Quaternion values to Euler angles.
        float roll  = (float) atan2(2*qy*qw - 2*qx*qz, 1 - 2*qy*qy - 2*qz*qz);
        float pitch = (float) atan2(2*qx*qw - 2*qy*qz, 1 - 2*qx*qx - 2*qz*qz);
        float yaw   = (float) asin(2*qx*qy + 2*qz*qw);
        
        NSLog(@"SFL: %.2f, %.2f, %.2f", roll, pitch, yaw);
        
        CATransform3D transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
        
        CGFloat modelScale = self.view.frame.size.width / 50;
        transform = CATransform3DScale(transform, modelScale, -modelScale, modelScale);
        
        // Add roll, pitch, yaw.
        transform = CATransform3DRotate(transform, roll, 1.0f, 0.0f, 0.0f);
        transform = CATransform3DRotate(transform, yaw, 0.0f, 1.0f, 0.0f);
        transform = CATransform3DRotate(transform, pitch, 0.0f, 0.0f, 1.0f);
        
        // Apply transformations necessary for the object.
        transform = CATransform3DRotate(transform, M_PI/2, 1.0f, 0.0f, 0.0f);
        transform = CATransform3DRotate(transform, M_PI, 0.0f, 1.0f, 0.0f);
        
        // Align object's center.
        //transform = CATransform3DTranslate(transform, 0, -12.0f, 0);
        
        self.modelView.modelTransform = transform;
    }
}

@end
