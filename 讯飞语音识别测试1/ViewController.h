//
//  ViewController.h
//  讯飞语音识别测试1
//
//  Created by 王克 on 16/1/21.
//  Copyright © 2016年 车益佰. All rights reserved.
//

#import <UIKit/UIKit.h>






//添加语音识别代理
@interface ViewController : UIViewController<UISearchBarDelegate>




//文本框用来显示识别结果
@property (weak, nonatomic) IBOutlet UITextField *textField;











@end

