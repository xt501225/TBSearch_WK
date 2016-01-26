//
//  ViewController.m
//  讯飞语音识别测试1
//
//  Created by 王克 on 16/1/21.
//  Copyright © 2016年 车益佰. All rights reserved.
//

#import "ViewController.h"



//自定义搜索框
#import "HWSearchBar.h"

//搜索视图
#import "ModelSearchViewController.h"


/




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
       
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 80, 300, 30)];
    search.delegate = self;
    
    
//    //修改searchBar的默认颜色
//    UIView *segment = [search.subviews objectAtIndex:0];
//    [segment removeFromSuperview];
//    search.backgroundColor = WKRBGColor(240, 255, 255, 1);
//    
//    UITextField *searchField = [[search subviews] lastObject];
//    [searchField setReturnKeyType:UIReturnKeyDone];
    
//    search.backgroundImage = [UIImage ]

    search.barStyle = UIBarStyleDefault;
    search.keyboardType = UIKeyboardTypeDefault;
    search.placeholder = @"请输入你想要的产品";
    //右边显示取消按钮
//    search.showsCancelButton = YES;
    //右边显示搜索结果按钮
//    search.showsSearchResultsButton = YES;
    search.tintColor = WKRBGColor(240, 255, 255, 1);
    //显示搜索范围
//    search.showsScopeBar = YES;
//    search.scopeButtonTitles = [NSArray arrayWithObjects:@"BOY",@"GIRL",@"ALL",nil];
    
    
    
    [self.view addSubview:search];
    
//    HWSearchBar *search = [[HWSearchBar alloc] initWithFrame:CGRectMake(60, 80, 200, 30)];
//    
//    [self.view addSubview:search];
    

}




//开始要在输入框输入内容的时候的代理方法
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    ModelSearchViewController *modelSearchVC = [[ModelSearchViewController alloc] init];
    modelSearchVC.view.backgroundColor = [UIColor lightGrayColor];
    modelSearchVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:modelSearchVC animated:NO completion:nil];
    
    
    WKNSLog(@"11111");

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
