//
//  AppDelegate.h
//  CloudMusic
//
//  Created by lyf on 2018/5/9.
//  Copyright © 2018年 lyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicObj.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;



//关于播放器的一些全局变量
//我的音乐列表
@property (nonatomic, strong) NSMutableArray *musicList;
//播放器对象
@property(nonatomic, strong)AVPlayer *player;
//播放下一曲方式
@property(nonatomic) NSInteger playPattern;
//当前暂停还是播放状态
@property(nonatomic) NSInteger playState; //1是播放状态，0是暂停状态
//当前歌曲对象
@property(nonatomic,strong) MusicObj *musicObj;
//当前歌曲在MusicList序号
@property(nonatomic) NSInteger musicIndex;
//播放进度监控对象
@property(strong,nonatomic) id timeObserve;
- (void)saveContext;




@property(strong,nonatomic)CADisplayLink *displayLink;

@end

