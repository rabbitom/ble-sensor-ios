//
//  TableViewCell.h
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/22.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *types;


@end
