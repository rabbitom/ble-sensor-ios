//
//  HistoryChartView.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/26.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryChartView : UIView

@property (nonatomic,strong) UIScrollView *scrollView;

-(id)initWithFrame:(CGRect)frame unit:(NSString *)unit yMax:(CGFloat)ymax yMin:(CGFloat)ymin xTimeArray:(NSArray *)xTimeArray xValueArray:(NSArray *)xValueArray type:(NSString *)type ;

-(id)initWithFrame:(CGRect)frame xValueArray:(NSArray *)xValueArray;

@end
