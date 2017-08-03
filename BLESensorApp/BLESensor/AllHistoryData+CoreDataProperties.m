//
//  AllHistoryData+CoreDataProperties.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/8/3.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "AllHistoryData+CoreDataProperties.h"

@implementation AllHistoryData (CoreDataProperties)

+ (NSFetchRequest<AllHistoryData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AllHistoryData"];
}

@dynamic deviceUUID;
@dynamic duration;
@dynamic iD;
@dynamic time;
@dynamic title;
@dynamic type;
@dynamic history_data;

@end
