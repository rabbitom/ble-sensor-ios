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


@interface GraphicalViewController ()<UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) HistoryPathView *pathView;
@property (nonatomic,strong) HistoryChartView *chartView;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
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

//生成Excel文件
-(void)data:(NSArray *)dataArray
{
    SomeType *someType = (SomeType *)dataArray[0];
    NSString *value = someType.value;
    NSArray *arr = [value componentsSeparatedByString:@"*"];
    int number = (int)[arr count] - 2;

    // 创建存放XLS文件数据的数组
    NSMutableArray  *xlsDataMuArr = [[NSMutableArray alloc] init];
    // 第一行内容
    [xlsDataMuArr addObject:@"time"];
    if (number == 2) {
        [xlsDataMuArr addObject:@"Value"];
    }else if(number == 3){
        [xlsDataMuArr addObject:@"X"];
        [xlsDataMuArr addObject:@"Y"];
    }else if(number == 4){
        [xlsDataMuArr addObject:@"X"];
        [xlsDataMuArr addObject:@"Y"];
        [xlsDataMuArr addObject:@"Z"];
        
    }
    // 行数据
    for (int i = 0; i < dataArray.count; i++) {
        SomeType *sometype1 = (SomeType *)dataArray[i];
        [xlsDataMuArr addObject:sometype1.time];
        for (int j = 1; j < number; j++) {
            NSString *values = sometype1.value;
            NSArray *arr = [values componentsSeparatedByString:@"*"];
            NSString *str = [NSString stringWithFormat:@"%@%@",arr[j - 1],arr[arr.count - 3]];
            [xlsDataMuArr addObject:str];
        }
    }
    
    // 把数组拼接成字符串，连接符是 \t（功能同键盘上的tab键）
    NSString *fileContent = [xlsDataMuArr componentsJoinedByString:@"\t"];
    // 字符串转换为可变字符串，方便改变某些字符
    NSMutableString *muStr = [fileContent mutableCopy];
    // 新建一个可变数组，存储每行最后一个\t的下标（以便改为\n）
    NSMutableArray *subMuArr = [NSMutableArray array];
    for (int i = 0; i < muStr.length; i ++) {
        NSRange range = [muStr rangeOfString:@"\t" options:NSBackwardsSearch range:NSMakeRange(i, 1)];
        if (range.length == 1) {
            [subMuArr addObject:@(range.location)];
        }
    }
    // 替换末尾\t
    for (NSUInteger i = 0; i < subMuArr.count; i ++) {
        //#warning  下面的6是列数，根据需求修改
        if ( i > 0 && (i%4 == 0) ) {
            [muStr replaceCharactersInRange:NSMakeRange([[subMuArr objectAtIndex:i-1] intValue], 1) withString:@"\n"];
        }
    }
    // 文件管理器
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *fileData = [muStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"/Documents/export.csv"];
    NSLog(@"文件路径：\n%@",filePath);
    // 生成xls文件
    [fileManager createFileAtPath:filePath contents:fileData attributes:nil];
    
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    
    self.documentInteractionController.delegate = self;
//    [self.documentInteractionController presentPreviewAnimated:YES];
//    [self.documentInteractionController presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    [self.documentInteractionController presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    

}

- ( UIViewController *)documentInteractionControllerViewControllerForPreview:( UIDocumentInteractionController *)interactionController
{
    return self;
}


-(void)click:(UIButton *)sender
{
    [self data:_dataArray ];
//    NSArray* imageArray = @[[UIImage imageNamed:@"播放_normal"]];
////    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeAuto];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//                       
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
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
