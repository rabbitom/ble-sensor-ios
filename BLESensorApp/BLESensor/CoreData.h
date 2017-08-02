//
//  CoreData.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/21.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AllHistoryData+CoreDataProperties.h"
#import "SomeType+CoreDataProperties.m"

@interface CoreData : NSObject

@property (nonatomic,strong) AllHistoryData *allHistoryData;
@property (nonatomic,strong) SomeType *someType;
@property (nonatomic,strong) AppDelegate *myApp;

+(instancetype)shareCoreData;

//增加某项服务数据
-(void)addCoreData:(NSDictionary *)historyDict SomeType:(NSMutableArray *)someTypeArray;

//查询某项服务数据
-(id)queryCoreData:(NSString *)typeStr data:(NSString *)dataStr uuid:(NSString *)uuid;

//删除某项数据
-(void)deleteCoreData:(id)AllHistory;

//修改某项数据名字
-(void)changeCoreData:(id)AllHistory name:(NSString *)name;
@end
