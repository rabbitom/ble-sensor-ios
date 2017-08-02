//
//  HistoryPathView.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/26.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "HistoryPathView.h"
#import "WSLineChartView.h"

@implementation HistoryPathView

-(id)initWithFrame:(CGRect)frame unit:(NSString *)unit yMax:(CGFloat)ymax yMin:(CGFloat)ymin xTimeArray:(NSArray *)xTimeArray xValueArray:(NSArray *)xValueArray type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        WSLineChartView *wsLine = [[WSLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height) xTitleArray:xTimeArray yValueArray:xValueArray yMax:ymax yMin:ymin unity:unit type:type];
        [self addSubview:wsLine];
    }
    return self;
}

//-(void)initLoad
//{
//    WSLineChartView *wsLine = [[WSLineChartView alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 500) xTitleArray:xArray yValueArray:yArray yMax:80 yMin:0];
//    [self addSubview:wsLine];
//}

@end
