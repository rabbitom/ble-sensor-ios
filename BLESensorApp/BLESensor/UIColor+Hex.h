//
//  UIColor+Hex.h
//  SunMall
//
//  Created by huangshupeng on 15/11/19.
//  Copyright © 2015年 huangshupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(float)opacity;
@end
