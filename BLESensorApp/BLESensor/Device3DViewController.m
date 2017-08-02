//
//  Device3DViewController.m
//  BLESensor
//
//  Created by 郝建林 on 2016/10/10.
//  Copyright © 2016年 CoolTools. All rights reserved.
//

#import "Device3DViewController.h"
#import <BLESensorSDK/BLESensorSDK.h>

@interface Device3DViewController ()
{
    NGLMesh *mesh;
    NGLCamera *camera;
    NGLQuaternion *quaternion;
    BLEIoTSensor *sensor;
    SensorFeature *sfl;
    float roll, pitch, yaw;
}
@end

@implementation Device3DViewController

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
    nglGlobalAntialias(NGLAntialias4X);
    nglGlobalFlush();
    mesh = [[NGLMesh alloc] initWithFile: @"YunjiaBlue.obj" settings:@{kNGLMeshCentralizeYes:@YES, kNGLMeshKeyNormalize:@0.5f} delegate:nil];
    camera = [[NGLCamera alloc] initWithMeshes: mesh, nil];
    quaternion = [[NGLQuaternion alloc] init];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) drawView {
    //Dialog
//    mesh.rotateX = -quaternion.euler.y;
//    mesh.rotateY = quaternion.euler.x;
//    mesh.rotateZ = quaternion.euler.z;
    //YunjiaBlue
    mesh.rotateX = quaternion.euler.x;
    mesh.rotateY = quaternion.euler.y;
    mesh.rotateZ = quaternion.euler.z;
    [camera drawCamera];
}

- (void)onDeviceValueChanged: (NSNotification*)notification {
    NSString *key = notification.userInfo[@"key"];
    if(key == nil)
        return;
    if([key isEqualToString:sfl.name]) {
        float qw = [(NSNumber*)sfl.values[0] floatValue];
        float qx = [(NSNumber*)sfl.values[1] floatValue];
        float qy = [(NSNumber*)sfl.values[2] floatValue];
        float qz = [(NSNumber*)sfl.values[3] floatValue];
        [quaternion rotateByQuaternionVector:nglVec4Make(qx, qy, qz, qw) mode:NGLAddModeSet];
    }
}

@end
