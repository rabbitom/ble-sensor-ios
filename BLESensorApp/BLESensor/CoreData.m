//
//  CoreData.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/21.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "CoreData.h"

@interface CoreData()

@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext1;
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,strong)NSPersistentContainer *persistentContainer;

@end

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

#pragma mark -iOS8,iOS9 CoreData Stack

//获取沙盒路径URL
-(NSURL*)getDocumentsUrl
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

//懒加载managedObjectModel
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    //    //根据某个模型文件路径创建模型文件
    //    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
    
}

//懒加载persistentStoreCoordinator
-(NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //根据模型文件创建存储调度器
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    /**
     *  给存储调度器添加存储器
     *
     *  tyep:存储类型
     *  configuration：配置信息 一般为nil
     *  options：属性信息  一般为nil
     *  URL：存储文件路径
     */
    
    NSURL *url = [[self getDocumentsUrl] URLByAppendingPathComponent:@"person.db" isDirectory:YES];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    NSLog(@"%@",_persistentStoreCoordinator.persistentStores[0].URL);
    
    return _persistentStoreCoordinator;
    
}
//懒加载managedObjectContext
-(NSManagedObjectContext*)managedObjectContext1
{
    if (_managedObjectContext1 != nil) {
        return _managedObjectContext1;
    }
    
    //参数表示线程类型  NSPrivateQueueConcurrencyType比NSMainQueueConcurrencyType略有延迟
    _managedObjectContext1 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置存储调度器
    [_managedObjectContext1 setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _managedObjectContext1;
}
#pragma mark -iOS10 CoreData Stack

//懒加载NSPersistentContainer
- (NSPersistentContainer *)persistentContainer
{
    if(_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //1.创建对象管理模型
    //    //根据某个模型文件路径创建模型文件
    //    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    
    
    //2.创建NSPersistentContainer
    /**
     * name:数据库文件名称
     */
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"sql.db" managedObjectModel:model];
    
    //3.加载存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * description, NSError * error) {
        NSLog(@"%@",description);
        NSLog(@"%@",error);
    }];
    
    return _persistentContainer;
}
#pragma mark - NSManagedObjectContext

//重写get方法
- (NSManagedObjectContext *)managedObjectContext
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0)
    {
        return MCoreDataManager.managedObjectContext1;
    }
    else
    {
        return MCoreDataManager.persistentContainer.viewContext;
    }
}
- (NSPersistentContainer *)getCurrentPersistentContainer
{
    //获取系统版本
    float systemNum = [[UIDevice currentDevice].systemVersion floatValue];
    
    //根据系统版本返回不同的NSManagedObjectContext
    if(systemNum < 10.0)
    {
        return nil;
    }
    else
    {
        return _persistentContainer;
    }
}

- (void)saveContext
{
    NSError *error = nil;
    [MCoreDataManager.managedObjectContext save:&error];
    
    if (error == nil) {
        NSLog(@"保存到数据库成功");
    }
    else
    {
        NSLog(@"保存到数据库失败：%@",error);
    }
}

//增加某项服务数据
-(void)addCoreData:(NSDictionary *)historyDict SomeType:(NSMutableArray *)someTypeArray
{
//    _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _allHistoryData = [NSEntityDescription insertNewObjectForEntityForName:@"AllHistoryData" inManagedObjectContext:[self managedObjectContext]];
    if (historyDict.count > 0) {
        _allHistoryData.iD = [NSString stringWithFormat:@"%@",historyDict[@"id"]];
        _allHistoryData.time = historyDict[@"time"];
        _allHistoryData.duration = [NSString stringWithFormat:@"%@",historyDict[@"duration"]];
        _allHistoryData.type = [NSString stringWithFormat:@"%@",historyDict[@"type"]];
        _allHistoryData.title = [NSString stringWithFormat:@"%@",historyDict[@"title"]];
        _allHistoryData.deviceUUID = [NSString stringWithFormat:@"%@",historyDict[@"deviceUUID"]];
    }
    [self saveContext];
    for (NSDictionary *dict in someTypeArray) {
        _someType = [NSEntityDescription insertNewObjectForEntityForName:@"SomeType" inManagedObjectContext:[self managedObjectContext]];
        _someType.iD = [NSString stringWithFormat:@"%@",historyDict[@"id"]];
        _someType.time = dict[@"time"];
        _someType.value = [NSString stringWithFormat:@"%@",dict[@"value"]];
    }
    
    [self saveContext];
//    NSError *error = nil;
//    if ([_myApp.persistentContainer.viewContext save:&error]) {
//        NSLog(@"插入成功");
//    }else{
//        NSLog(@"error = %@",error.debugDescription);
//    }

}

//查询某项服务数据
-(id)queryCoreData:(NSString *)typeStr data:(NSString *)dataStr uuid:(NSString *)uuid
{
    _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableArray *dataArray1 = [NSMutableArray array];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:typeStr];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    request.sortDescriptors = @[sort];
    NSError *error = nil;
    NSArray *result = [[self managedObjectContext] executeFetchRequest:request error:&error];
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
    [[self managedObjectContext] deleteObject:AllHistory];
    [self saveContext];
}

//修改某项数据
-(void)changeCoreData:(id)AllHistory name:(NSString *)name
{
     _myApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AllHistoryData *history = (AllHistoryData *)AllHistory;
    history.title = [NSString stringWithFormat:@"%@",name];
    [self saveContext];
}

@end
