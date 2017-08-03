//
//  AllHistoryData+CoreDataProperties.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/8/3.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "AllHistoryData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AllHistoryData (CoreDataProperties)

+ (NSFetchRequest<AllHistoryData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deviceUUID;
@property (nullable, nonatomic, copy) NSString *duration;
@property (nullable, nonatomic, copy) NSString *iD;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) NSSet<SomeType *> *history_data;

@end

@interface AllHistoryData (CoreDataGeneratedAccessors)

- (void)addHistory_dataObject:(SomeType *)value;
- (void)removeHistory_dataObject:(SomeType *)value;
- (void)addHistory_data:(NSSet<SomeType *> *)values;
- (void)removeHistory_data:(NSSet<SomeType *> *)values;

@end

NS_ASSUME_NONNULL_END
