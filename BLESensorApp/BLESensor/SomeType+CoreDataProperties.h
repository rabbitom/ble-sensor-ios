//
//  SomeType+CoreDataProperties.h
//  
//
//  Created by 张虎 on 2017/7/17.
//
//

#import "SomeType+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SomeType (CoreDataProperties)

+ (NSFetchRequest<SomeType *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *iD;
@property (nullable, nonatomic, copy) NSDate *time;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, retain) AllHistoryData *some_type;

@end

NS_ASSUME_NONNULL_END
