//
//  HistoryDataViewController.m
//  BLESensorApp
//
//  Created by 张虎 on 2017/6/20.
//  Copyright © 2017年 CoolTools. All rights reserved.
//

#import "HistoryDataViewController.h"
#import "TableViewCell.h"
#import "CoreData.h"
#import "UIColor+Hex.h"
#import "AllHistoryData+CoreDataProperties.h"
#import "GraphicalViewController.h"

@interface HistoryDataViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BLEIoTSensor *sensor;
}

@property (nonatomic,strong) NSString *currentDeviceUUID;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableViewRowAction *action0;
@property (nonatomic,strong) UITableViewRowAction *action1;
@property (nonatomic,strong) UITableViewRowAction *action2;

@end

@implementation HistoryDataViewController

- (BLEDevice*)device {
    return sensor;
}

- (void)setDevice:(BLEDevice *)device {
    
    if(device.class == BLEIoTSensor.class) {
        sensor = (BLEIoTSensor*)device;
        if(self.device != nil) {
            if(!self.device.isConnected) {
                [self.device connect];
            }
        }
        NSDictionary *dict = [BLEIoTSensor services];
        NSArray *uuid = [dict allKeys];
        if (uuid.count == 1) {
            _currentDeviceUUID = [NSString stringWithFormat:@"%@",uuid[0]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _dataArray = [[CoreData shareCoreData] queryCoreData:@"AllHistoryData" data:nil uuid:_currentDeviceUUID];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headView];
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40 + 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

-(void)headView
{
    NSArray *array = @[@"标题",@"开始时间",@"持续时间",@"类型"];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    [self.view addSubview:headView];
    for (int i = 0; i < 4; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*i, 0, self.view.frame.size.width/4, 40)];
        title.text = [NSString stringWithFormat:@"%@",array[i]];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:title];
        if (i > 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*i, 5, 1, 30)];
            line.backgroundColor = [UIColor grayColor];
            [headView addSubview:line];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil];
        cell = nibArray[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(_dataArray.count > 0) {
        AllHistoryData *history = (AllHistoryData *)_dataArray[indexPath.row];
        cell.title.text = [NSString stringWithFormat:@"%@",history.title];
        cell.time.text = [NSString stringWithFormat:@"%@",history.time];
        cell.duration.text = [NSString stringWithFormat:@"%@s",history.duration];
        cell.types.text = [NSString stringWithFormat:@"%@",history.type];
    }
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改标题" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        AllHistoryData *history = (AllHistoryData *)_dataArray[indexPath.row];
        [self change:history nubmer:indexPath];
    }];
    _action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        AllHistoryData *history = (AllHistoryData *)_dataArray[indexPath.row];
        [[CoreData shareCoreData] deleteCoreData:history];
        
        [_dataArray removeObject:history];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
//    _action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"导出" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        AllHistoryData *history = (AllHistoryData *)_dataArray[indexPath.row];
//        
//        NSArray *dataArray = [[CoreData shareCoreData] queryCoreData:@"SomeType" data:history.iD uuid:nil];
//        [self data:dataArray name:history.title type:history.type];
//        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }];
    _action0.backgroundColor = [UIColor colorWithHexString:@"#03DD7E"];
    _action1.backgroundColor = [UIColor redColor];
//    _action2.backgroundColor = [UIColor brownColor];
//    return @[_action1,_action0,_action2];
    return @[_action1,_action0];
}



//删除
-(void)change:(id)obj nubmer:(NSIndexPath *)index
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入要修改标题名" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *title = alertController.textFields.firstObject;
        [[CoreData shareCoreData] changeCoreData:obj name:title.text];
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入标题名";
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

//-(NSString *)setDate:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";
//    NSLog(@"%@",[dateFormatter stringFromDate:date]);
//    return [dateFormatter stringFromDate:date];
//}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"GraphicalView" sender:_dataArray[indexPath.row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GraphicalViewController *graphilViewController = segue.destinationViewController;
    AllHistoryData *history = (AllHistoryData *)sender;
    graphilViewController.date = history.iD;
}


@end
