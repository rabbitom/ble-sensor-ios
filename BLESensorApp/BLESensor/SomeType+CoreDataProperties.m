//
//  SomeType+CoreDataProperties.m
//  
//
//  Created by 张虎 on 2017/7/17.
//
//

#import "SomeType+CoreDataProperties.h"

@implementation SomeType (CoreDataProperties)

+ (NSFetchRequest<SomeType *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SomeType"];
}

@dynamic iD;
@dynamic time;
@dynamic value;
@dynamic some_type;

@end
