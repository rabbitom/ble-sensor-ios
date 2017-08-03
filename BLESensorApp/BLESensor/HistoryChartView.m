//
//  HistoryChartView.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/26.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "HistoryChartView.h"
#import "WSLineChartView.h"
#import "SomeType+CoreDataProperties.h"

@implementation HistoryChartView

-(id)initWithFrame:(CGRect)frame unit:(NSString *)unit yMax:(CGFloat)ymax yMin:(CGFloat)ymin xTimeArray:(NSArray *)xTimeArray xValueArray:(NSArray *)xValueArray type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        WSLineChartView *wsChart = [[WSLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , self.frame.size.height) xTitleArray:xTimeArray yValueArray:xValueArray yMax:ymax yMin:ymin unity:unit type:type];
        [self addSubview:wsChart];

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame xValueArray:(NSArray *)xValueArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        [self initLoad:xValueArray];
    }
    return self;
}

-(void)initLoad:(NSArray *)array
{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(0, 50*array.count);
    [self addSubview:_scrollView];
    int number = 0;
    if (array.count > 0) {
        SomeType *someType = (SomeType *)array[0];
        NSString *value = someType.value;
        NSArray *arr = [value componentsSeparatedByString:@"*"];
        number = (int)[arr count] - 2;
        NSArray *nameArray = [NSArray array];
        if (number == 2) {
            nameArray = @[@"Time",@"Value"];
        }else if(number == 3){
            nameArray = @[@"Time",@"X",@"Y"];
        }else if(number == 4){
            nameArray = @[@"Time",@"X",@"Y",@"Z"];
        }
        
        for (int i = 0; i < number; i++) {
            for (int j = 0; j < array.count; j++) {
                UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 50*j, self.frame.size.width, 0.5)];
                view1.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
                [_scrollView addSubview:view1];
                
                UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/number*j, 0, 0.5, 50*array.count)];
                view2.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
                [_scrollView addSubview:view2];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/number*i, 50*j, self.frame.size.width/number, 50)];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.numberOfLines = 0;
                if (j == 0) {
                    label.text = [NSString stringWithFormat:@"%@",nameArray[i]];
                }else{
                    SomeType *someType1 = (SomeType *)array[j - 1];
                    if (i == 0) {
                       label.text = [NSString stringWithFormat:@"%@",someType1.time];
                    }else{
                        NSString *values = someType1.value;
                        NSArray *arr = [values componentsSeparatedByString:@"*"];
                        label.text = [NSString stringWithFormat:@"%@%@",arr[i-1],arr[arr.count - 3]];
                    }
                }
                [_scrollView addSubview:label];
            }
        }
    }
}


@end
