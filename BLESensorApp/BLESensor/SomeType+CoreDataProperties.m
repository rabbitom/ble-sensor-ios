//
//  SomeType+CoreDataProperties.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/8/3.
//  Copyright © 2017年 CoolTools. All rights reserved.
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
