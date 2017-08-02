//
//  CoreData.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/21.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

+(instancetype)shareCoreData
{
    static CoreData *coreData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreData = [[CoreData alloc] init];
    });
    return coreData;
}

//增加某项服务数据
-(void)addCoreData:(NSDictionary *)historyDict SomeType:(NSMutableArray *)someTypeArray
{
    _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _allHistoryData = [NSEntityDescription insertNewObjectForEntityForName:@"AllHistoryData" inManagedObjectContext:_myApp.persistentContainer.viewContext];
    if (historyDict.count > 0) {
        _allHistoryData.iD = [NSString stringWithFormat:@"%@",historyDict[@"id"]];
        _allHistoryData.startTime = historyDict[@"stratTime"];
        _allHistoryData.duration = [NSString stringWithFormat:@"%@",historyDict[@"duration"]];
        _allHistoryData.type = [NSString stringWithFormat:@"%@",historyDict[@"type"]];
        _allHistoryData.title = [NSString stringWithFormat:@"%@",historyDict[@"title"]];
        _allHistoryData.deviceUUID = [NSString stringWithFormat:@"%@",historyDict[@"deviceUUID"]];
    }
    [_myApp saveContext];
    for (NSDictionary *dict in someTypeArray) {
        _someType = [NSEntityDescription insertNewObjectForEntityForName:@"SomeType" inManagedObjectContext:_myApp.persistentContainer.viewContext];
        _someType.iD = [NSString stringWithFormat:@"%@",historyDict[@"id"]];
        _someType.time = dict[@"time"];
        _someType.value = [NSString stringWithFormat:@"%@",dict[@"value"]];
    }
    
    [_myApp saveContext];
    NSError *error = nil;
    if ([_myApp.persistentContainer.viewContext save:&error]) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"error = %@",error.debugDescription);
    }

}

//查询某项服务数据
-(id)queryCoreData:(NSString *)typeStr data:(NSString *)dataStr uuid:(NSString *)uuid
{
    _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *dataArray1 = [NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:typeStr];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"iD" ascending:NO];
    request.sortDescriptors = @[sort];
    NSError *error = nil;
    NSArray *result = [_myApp.persistentContainer.viewContext executeFetchRequest:request error:&error];
    if (dataStr == nil){
        for (id allData in result) {
            AllHistoryData *data = (AllHistoryData *)allData;
            if ([data.deviceUUID isEqualToString:uuid]) {
                [dataArray1 addObject:data];
            }
        }
        return dataArray1;
    }else{
        for (id allData in result){
            SomeType *data = (SomeType *)allData;
            if ([data.iD isEqual:dataStr]) {
                [dataArray addObject:allData];
            }
        }
        return dataArray;
    }
    
}

//删除某项数据
-(void)deleteCoreData:(id)AllHistory
{
    _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [_myApp.persistentContainer.viewContext deleteObject:AllHistory];
    [_myApp saveContext];
}

//修改某项数据
-(void)changeCoreData:(id)AllHistory name:(NSString *)name
{
     _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AllHistoryData *history = (AllHistoryData *)AllHistory;
    history.title = [NSString stringWithFormat:@"%@",name];
    [_myApp saveContext];
}

@end
