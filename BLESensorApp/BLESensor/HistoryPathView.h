//
//  HistoryPathView.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/26.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryPathView : UIView

-(id)initWithFrame:(CGRect)frame unit:(NSString *)unit yMax:(CGFloat)ymax yMin:(CGFloat)ymin xTimeArray:(NSArray *)xTimeArray xValueArray:(NSArray *)xValueArray type:(NSString *)type;
@end
