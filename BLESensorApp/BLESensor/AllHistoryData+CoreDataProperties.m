//
//  AllHistoryData+CoreDataProperties.m
//  
//
//  Created by 张虎 on 2017/7/17.
//
//

#import "AllHistoryData+CoreDataProperties.h"

@implementation AllHistoryData (CoreDataProperties)

+ (NSFetchRequest<AllHistoryData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AllHistoryData"];
}

@dynamic duration;
@dynamic iD;
@dynamic startTime;
@dynamic title;
@dynamic type;
@dynamic deviceUUID;
@dynamic history_data;

@end
