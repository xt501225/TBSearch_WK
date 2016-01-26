//
//  ModelSearchViewController.h
//  讯飞语音识别测试1
//
//  Created by 王克 on 16/1/25.
//  Copyright © 2016年 车益佰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <iflyMSC/IFlyDataUploader.h>

#import "iflyMSC/IFlySpeechRecognizer.h"


//引入语音识别类
@class IFlyDataUploader;
@class IFlySpeechUnderstander;

@interface ModelSearchViewController : UIViewController<IFlySpeechRecognizerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    
    UISearchBar *_search;
    
    UITableView *_searchHistoryTabelVeiwList;
    NSArray *searchHistoryDataList;
    NSMutableArray *searchGoodDataList;

}
@property (nonatomic, strong) IFlySpeechUnderstander  *iflySpeechUnderstander;

//识别结果
@property (nonatomic, strong) NSString *result;
//识别结果字符串
@property (nonatomic, strong) NSString *str_result;

@property (nonatomic) BOOL  isCanceled;



@end
