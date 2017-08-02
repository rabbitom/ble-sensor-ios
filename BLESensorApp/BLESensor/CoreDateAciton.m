//
//  CoreDateAciton.m
//  VylyV
//
//  Created by 张虎 on 2017/1/12.
//  Copyright © 2017年 张虎. All rights reserved.
//

#import "CoreDateAciton.h"
//#import "UserData+CoreDataProperties.h"
//#import "HomeData+CoreDataProperties.h"

@interface CoreDateAciton()

@property (nonatomic,strong) NSUserDefaults *userDefault;

@end

@implementation CoreDateAciton


@synthesize UserName = _UserName;


+ (instancetype)shareManager
{
    static CoreDateAciton *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[CoreDateAciton alloc] init];
    });
    return dataManager;
}


- (NSString *)getStringNil:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]] || !string ) {
        string = @"";
    }
    string = [NSString stringWithFormat:@"%@",string];
    return string;
}

-(NSUserDefaults *)userDefault
{
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}
//保存用户名
-(void)setUserName:(NSString *)UserName
{
    _UserName = UserName;
    [self.userDefault setObject:_UserName forKey:@"DefaultsUser"];
    [self.userDefault synchronize];
}
//获取设备ID
-(NSString *)UserName
{
    _UserName = [self getStringNil:[self.userDefault objectForKey:@"DefaultsUser"]];
    return _UserName;
}

-(void)initDategate
{
    self.myAppDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
}

////增 dateName
//-(void)addData:(NSString *)dateName setUserName:(NSString *)userName  data:(NSDictionary *)dict
//{
//    [self initDategate];
//    UserData *result = [self checkData:@"UserData" setUserName:userName data:nil];
//    if (result == nil || [result isKindOfClass:[NSNull class]]) {
//        //创建实体描述
//        NSEntityDescription *description = [NSEntityDescription entityForName:@"UserData" inManagedObjectContext:self.myAppDelegate.persistentContainer.viewContext];
//        UserData *user = [[UserData alloc] initWithEntity:description insertIntoManagedObjectContext:self.myAppDelegate.persistentContainer.viewContext];
//        user.userid = [NSString stringWithFormat:@"%@",dict[@"userid"]];
//        
//    }else{
//        if ([dateName isEqualToString:@"HomeData"]) {
//            NSEntityDescription *description1 = [NSEntityDescription entityForName:@"HomeData" inManagedObjectContext:self.myAppDelegate.persistentContainer.viewContext];
//            HomeData *home = [[HomeData alloc] initWithEntity:description1 insertIntoManagedObjectContext:self.myAppDelegate.persistentContainer.viewContext];
//            home.data = [dict[@"data"] floatValue];
//            home.time = dict[@"time"];
//            [result addRelationshipObject:home];
//        }
//    }
//     [self.myAppDelegate saveContext];
//    
//}
//
////删
//-(void)deleteData:(NSString *)dateName setUserName:(NSString *)userName 
//{
//    [self initDategate];
//    UserData *result = [self checkData:dateName setUserName:userName data:nil];
//    if (result != nil && ![result isKindOfClass:[NSNull class]]) {
//        [self.myAppDelegate.persistentContainer.viewContext deleteObject:result];
//        [self.myAppDelegate saveContext];
//    }
//}
//
////改
//-(void)changeData:(id)dateName setUserName:(NSString *)userName data:(NSDictionary *)dict
//{
//    [self initDategate];
//    NSSet *Set = [self checkData:dateName setUserName:userName data:nil];
//    if ([dateName isEqualToString:@"HomeData"]) {
//        NSMutableArray *newArray = [NSMutableArray array];
//        if (Set.count > 0) {
//            for (HomeData *home  in Set) {
//                [newArray addObject:home];
//            }
//            HomeData *homedata = [newArray objectAtIndex:newArray.count - 1];
//            homedata.data = [dict[@"data"] floatValue];
//            homedata.time = dict[@"time"];
//        }
//    }
//    
//    [self.myAppDelegate saveContext];
//}
//
////查 dateName 实体的名字。 userName当前用户名 string实体中属性
//-(id)checkData:(NSString *)dateName setUserName:(NSString *)userName data:(NSString *)string
//{
//    [self initDategate];
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"UserData"];
//    
//    // 设置查询条件
//    if (string != nil) {
//        NSPredicate *pre = [NSPredicate predicateWithFormat:string];
//        request.predicate = pre;
//    }
//   
//    NSError *error = nil;
//    NSArray *result =  [self.myAppDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
//    
//        for (UserData *userData in result) {
//            if ([userData.userid isEqualToString:userName]) {
//                if ([dateName isEqualToString:@"UserData"])
//                {
//                    return userData;
//                }else if ([dateName isEqualToString:@"HomeData"]){
//                    return userData.relationship;
//                }
//            }
//        }
//    return nil;
//}

@end
