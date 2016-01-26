//
//  ModelSearchViewController.m
//  讯飞语音识别测试1
//
//  Created by 王克 on 16/1/25.
//  Copyright © 2016年 车益佰. All rights reserved.
//

#import "ModelSearchViewController.h"
//续费语音识别用到的 头文件
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>

#import <iflyMSC/IFlyContact.h>
#import <iflyMSC/IFlyDataUploader.h>
#import <iflyMSC/IFlyUserWords.h>

#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlySpeechUnderstander.h>



@interface ModelSearchViewController ()

@end

@implementation ModelSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //创建识别对象
    //创建语音配置
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",@"56775a54",@"20000"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    _iflySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    _iflySpeechUnderstander.delegate = self;
 
    //历史记录数组
    NSArray *array = [[NSArray alloc]initWithObjects:@"广州",@"深圳",@"梅州",@"东莞",@"潮汕",@"肇庆",@"四会",@"佛山",@"湛江",@"江门",@"阳江",@"珠海", nil];
    searchHistoryDataList = array;
    //搜索出来的商品名称 数组
    searchGoodDataList =[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"55",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    
    //搜索框（添加到当前View上的~>模态视图上）
    _search = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 80, 300, 30)];
//    _search = [[UISearchBar alloc] init];
    _search.delegate = self;
    _search.barStyle = UIBarStyleDefault;
    _search.keyboardType = UIKeyboardTypeDefault;
    _search.placeholder = @"请输入你想要的产品";
    _search.tintColor = WKRBGColor(240, 255, 255, 1);
    [self.view addSubview:_search];
    //开始自动布局
    
    
    //表视图（用来显示搜索词历史记录的）
    _searchHistoryTabelVeiwList = [[UITableView alloc] initWithFrame:CGRectMake(30, 110, 300, 300) style:UITableViewStylePlain];
    _searchHistoryTabelVeiwList.dataSource = self;
    _searchHistoryTabelVeiwList.delegate = self;
    //    _searchHistoryTabelVeiwList.hidden = YES;
    _searchHistoryTabelVeiwList.tag = 2015;
    [self.view addSubview:_searchHistoryTabelVeiwList];
    
    //给背景模态视图添加一个tap手势， 使得点击表视图之外的其他地方退出模态视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    //添加两个按钮来监听 录音d 开始和结束
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(30, 500, 100, 30);
    startButton.backgroundColor = WKRBGColor(176, 224, 230, 1) ;
    [self.view addSubview:startButton];
    
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    //注意，需要先将view加入到父视图之后才能进行 自动布局
    
//    startButton.sd_layout.leftSpaceToView
    
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(190, 500, 100, 30);
    finishButton.backgroundColor = WKRBGColor(176, 224, 230, 1) ;
    [finishButton setTitle:@"停止" forState:UIControlStateNormal];
    
    [finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    
}

//背景视图上添加的tap手势，用来点击回去
- (void)tapAction{

    [self dismissViewControllerAnimated:NO completion:nil];

}


//开始按钮监听事件
- (void)startAction{

    BOOL ret = [_iflySpeechUnderstander startListening];//开始监听
    
    if (ret) {
        self.isCanceled = NO;
        
    }else{
        
        NSLog(@"启动监听失败");
    }

}

//完成按钮监听事件
- (void)finishAction{

     [_iflySpeechUnderstander stopListening]; //监听结束，开始识别

}




//输入框的内容改变调用方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    WKNSLog(@"22222");


    _searchHistoryTabelVeiwList = [[UITableView alloc] initWithFrame:CGRectMake(30, 110, 300, 300) style:UITableViewStylePlain];
    _searchHistoryTabelVeiwList.dataSource = self;
    _searchHistoryTabelVeiwList.delegate = self;
    _searchHistoryTabelVeiwList.tag = 2016;
    //    _searchHistoryTabelVeiwList.hidden = YES;

    _searchHistoryTabelVeiwList.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    _searchHistoryTabelVeiwList.tableFooterView.backgroundColor = WKRBGColor(209, 238, 238, 1) ;
                                                                   
    
    [self.view addSubview:_searchHistoryTabelVeiwList];


}

- (void)viewWillDisappear:(BOOL)animated{
    
    [_iflySpeechUnderstander cancel];
    _iflySpeechUnderstander.delegate = nil;
    
    //设置回非语义识别
    [_iflySpeechUnderstander destroy];
    [super viewWillDisappear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -searchHistoryTabelVeiwList delegate datasource
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"searchHistoryTabelVeiwListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //取得当前行
    NSUInteger row=[indexPath row];
    if (_searchHistoryTabelVeiwList.tag == 2015) {
        cell.textLabel.text=[searchHistoryDataList objectAtIndex:row]; //设置每一行要显示的值
    }else{
        
        cell.textLabel.text=[searchGoodDataList objectAtIndex:row]; //设置每一行要显示的值
    }
    
    
    
    
    return cell;
    
}


#pragma mark - IFlySpeechRecognizerDelegate
/**
 *  音量变化回调
 *
 *  @param volume 录音的音量，范围为 1~100
 */
- (void)onVolumeChanged:(int)volume{
    
}
/**
 *  开始识别回调
 */
- (void) onBeginOfSpeech{
    
}
/**
 *  停止录音回调
 */
- (void) onEndOfSpeech{
    
}
/**
 *  识别结果回调
 *  @param results 数组的第一个元素为字典，字典的key为识别结果，value为置信度
 *  @param isLast
 */
- (void) onResults:(NSArray *)results isLast:(BOOL)isLast{
    
    NSArray *temp = [[NSArray alloc] init];
    NSString *str = [[NSString alloc] init];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
        
    }
    
    WKNSLog(@"听写结果：%@",result);
    /************讯飞语音识别JSON数据*************/
    NSError *error;
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    
    WKNSLog(@"data:%@",data);
    NSDictionary *dic_result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *array_ws = [dic_result objectForKey:@"ws"];
    //遍历识别结果的每一个单词
    for (int i = 0; i < array_ws.count ; i++) {
        temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        NSDictionary *dic_cw = [temp objectAtIndex:0];
        str = [str stringByAppendingString:[dic_cw objectForKey:@"w"]];
        WKNSLog(@"识别结果：%@",[dic_cw objectForKey:@"w" ]);
    }
    
    WKNSLog(@"最终的识别结果：%@",str);
    
    //去掉识别结果最后的标点符号
    if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
        NSLog(@"末尾加上标点符号：%@",str);
        
    }else {
        //        self.content.text = str;
//        self.textField.text = str;
        _search.text = str;
        
    }
    
    _result = str;
    
}

/**
 *  识别结束回调
 *
 *  @param errorCode 错误类，具体见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *)errorCode{
    
    //    NSLog(@"识别出错!");
    //
    //    NSString *text ;
    //
    //        if (self.isCanceled) {
    //            text = @"识别取消";
    //        }else if (error.errorCode == 0){
    //            if (_result.length ==0 ) {
    //                text = @"无识别结果";
    //            }else{
    //                text = @"识别成功";
    //            }
    //
    //        }else {
    //
    //            text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errordesc];
    //
    //            NSLog(@"%@",text);
    //        }
    //    
    
}



@end
