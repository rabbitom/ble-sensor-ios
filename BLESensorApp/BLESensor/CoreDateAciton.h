//
//  CoreDateAciton.h
//  VylyV
//
//  Created by 张虎 on 2017/1/12.
//  Copyright © 2017年 张虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreDateAciton : NSObject

@property (nonatomic,strong) AppDelegate *myAppDelegate;

+ (instancetype)shareManager;

@property (nonatomic,copy) NSString *UserName;                  //设备ID

//增
-(void)addData:(NSString *)dateName setUserName:(NSString *)userName  data:(NSDictionary *)dict;

//删
-(void)deleteData:(id)dateName setUserName:(NSString *)userName;

//改
-(void)changeData:(id)dateName setUserName:(NSString *)userName data:(NSDictionary *)dict;

//查
-(id)checkData:(NSString *)dateName setUserName:(NSString *)userName data:(NSString *)string;

@end
