//
//  ViewController.m
//  CloudMusic
//
//  Created by lyf on 2018/5/9.
//  Copyright © 2018年 lyf. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property(nonatomic, strong) NSString *currentSong;
@property(nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *playUrl = [NSURL URLWithString:@"http://bmob-cdn-18965.b0.upaiyun.com/2018/05/10/db4c20dc40bfedf1800300eb54b86ded.mp3"];
    self.player.volume = 1.0;
    self.player = [[AVPlayer alloc] initWithURL:playUrl];
    [self.player play];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
