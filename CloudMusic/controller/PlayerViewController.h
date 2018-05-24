//
//  PlayerViewController.h
//  CloudMusic
//
//  Created by lyf on 2018/5/10.
//  Copyright © 2018年 lyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicObj.h"
@interface PlayerViewController : UIViewController
//进入view的方式
@property(nonatomic)NSInteger intoViewType; //0代表通过右上角按钮进入，1代表点击tableCell进入
@end
