//
//  SomeType+CoreDataProperties.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/8/3.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "SomeType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SomeType (CoreDataProperties)

+ (NSFetchRequest<SomeType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *iD;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, retain) AllHistoryData *some_type;

@end

NS_ASSUME_NONNULL_END
