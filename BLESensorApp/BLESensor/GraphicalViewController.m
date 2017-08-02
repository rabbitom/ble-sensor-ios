//
//  GraphicalViewController.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/26.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "GraphicalViewController.h"
#import "SomeType+CoreDataProperties.h"
#import "HistoryPathView.h"
#import "HistoryChartView.h"
#import "CoreData.h"

@interface GraphicalViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HistoryPathView *pathView;
@property (nonatomic,strong) HistoryChartView *chartView;

@end

@implementation GraphicalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLoad];
}

-(void)initRightButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 44, 40);
    [button setTitle:@"分享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)click:(UIButton *)sender
{
    
}

-(void)initLoad
{
    [self initLoad:@"Line"];
}

-(void)initLoad:(NSString *)type
{
    _dataArray = [[CoreData shareCoreData] queryCoreData:@"SomeType" data:_date uuid:nil];
    CGFloat yMax = 0.0;
    CGFloat yMin = 0.0;
    NSString *unit = @"";
    NSMutableArray *xTimeArray = [NSMutableArray array];
    NSMutableArray *xValueArray = [NSMutableArray array];
    for (int i = 0; i < _dataArray.count; i++) {
        [xTimeArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for (SomeType *sometype in _dataArray) {
        NSString *values = sometype.value;
        NSArray *array1 = [values componentsSeparatedByString:@"*"];
        NSMutableArray *array3 = [NSMutableArray array];
        if (array1.count >= 3) {
            yMax = [[NSString stringWithFormat:@"%@",array1[array1.count - 2]] floatValue];
            yMin = [[NSString stringWithFormat:@"%@",array1[array1.count - 1]] floatValue];
            unit = [NSString stringWithFormat:@"%@",array1[array1.count - 3]];
            for (int i = 0; i < array1.count - 3; i++) {
                [array3 addObject:array1[i]];
            }
        }
        [xValueArray addObject:array3];
    }
    if ([type isEqualToString:@"Line"]) {
        _pathView = [[HistoryPathView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 160) unit:unit yMax:yMax yMin:yMin xTimeArray:xTimeArray xValueArray:xValueArray type:@"Line"];
        [self.view addSubview:_pathView];
 
    }else if ([type isEqualToString:@"Chart"]){
        //柱形图
//        _chartView = [[HistoryChartView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 160) unit:unit yMax:yMax yMin:yMin xTimeArray:xTimeArray xValueArray:xValueArray type:@"Chart"];
        //图表
        _chartView = [[HistoryChartView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 160) xValueArray:_dataArray];
        [self.view addSubview:_chartView];
    }
}

- (IBAction)ActionSegment:(id)sender {
    [_pathView removeFromSuperview];
    [_chartView removeFromSuperview];
    
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        [self initLoad:@"Line"];
        self.navigationItem.rightBarButtonItem = nil;
    }else if(segment.selectedSegmentIndex == 1){
        if (self.navigationItem.rightBarButtonItem == nil){
            [self initRightButton];
        }
        [self initLoad:@"Chart"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
