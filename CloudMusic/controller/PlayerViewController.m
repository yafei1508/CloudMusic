//
//  PlayerViewController.m
//  CloudMusic
//
//  Created by lyf on 2018/5/10.
//  Copyright © 2018年 lyf. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
@interface PlayerViewController ()
//view界面
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playedTime;
@property (weak, nonatomic) IBOutlet UILabel *AllTime;
@property (weak, nonatomic) IBOutlet UIButton *playPatternButton;
@property (weak, nonatomic) IBOutlet UIView *ContainerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *needle;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
//全局app对象
@property(nonatomic, strong)AppDelegate * appDelegate;
//动画
@property(nonatomic, strong)CABasicAnimation *animation;


@end

@implementation PlayerViewController

//下一曲action
- (IBAction)nextMusic:(id)sender {
    [self nextMusic];
}
//上一曲action
- (IBAction)preMusic:(id)sender {
    [self preMusic];
}
//返回音乐列表
- (IBAction)backToTableView:(id)sender {
    [self dismissViewControllerAnimated:false completion:^{
        NSLog(@"fanhui");
    }];
}
//暂停开始button action
- (IBAction)touchPause:(id)sender {
    //暂停
    [self pauseMusic];
    
}
-(void) pauseMusic {
    if(self.appDelegate.playState == 1) {
        [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        self.appDelegate.playState = 0;
        [self.appDelegate.player pause];
        [self pauseLayer:self.imageView.layer];
        [self pausedWithAnimated:YES];
    }else {
        //开始
        [_pauseButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        self.appDelegate.playState = 1;
        [self.appDelegate.player play];
        [self resumeLayer:self.imageView.layer];
        [self playedWithAnimated:YES];
    }
}
//修改下一曲循环模式
- (IBAction)changePlayPattern:(id)sender {
    NSLog(@"%ld", (long)self.appDelegate.playPattern);
    switch (self.appDelegate.playPattern) {
        //0代表列表循环播放
        case 0:
            self.appDelegate.playPattern = 1;
            [_playPatternButton setImage:[UIImage imageNamed:@"单曲循环"] forState:UIControlStateNormal];
            break;
        //1代表单曲循环播放
        case 1:
            self.appDelegate.playPattern = 2;
            [_playPatternButton setImage:[UIImage imageNamed:@"随机播放"] forState:UIControlStateNormal];
            break;
        //2代表随机播放
        case 2:
            self.appDelegate.playPattern = 0;
            [_playPatternButton setImage:[UIImage imageNamed:@"列表循环"] forState:UIControlStateNormal];
            break;
        default:
            break;
        
    }
}
//拉动进度条改变音乐播放进度
- (IBAction)changeTime:(id)sender {
    [self pauseMusic];
    float allTime = CMTimeGetSeconds(_appDelegate.player.currentItem.duration);
    float nextBeginTime = self.musicSlider.value * allTime;
    [self.appDelegate.player seekToTime:CMTimeMake(nextBeginTime, 1)];
    [self pauseMusic];
}

//初始化界面
- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger width = [UIScreen mainScreen].bounds.size.width;
    //控制中间旋转视图的大小和位置以适应不同的iphone
    [self.ContainerImageView setFrame:CGRectMake(10, 125, width-20, width-20)];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    //初始化界面
    
    //修改通知栏明暗
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if(_intoViewType == 1) {
        //通过点击tableCell 播放歌曲
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_appDelegate.musicObj.musicUrl]];
        self.appDelegate.player = [[AVPlayer alloc] initWithPlayerItem:item];
        [self initView];
        [self playCurrentMusic];
        
        
    }else if(_intoViewType == 0) {
        //通过table右上角按钮进入播放视图
        if(_appDelegate.timeObserve) {
            [_appDelegate.player removeTimeObserver:_appDelegate.timeObserve];
            _appDelegate.timeObserve = nil;
        }
        _appDelegate.timeObserve = [self.appDelegate.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float AllTime = CMTimeGetSeconds(_appDelegate.player.currentItem.duration);
            if (current) {
                self.musicSlider.value = (current / AllTime);

                if(self.musicSlider.value < 0) {
                    self.playedTime.text =[NSString stringWithFormat:@"%@", [self getMMSSFromSS:0]];
                    self.AllTime.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:0]];
                }else {
                    self.playedTime.text =[NSString stringWithFormat:@"%@", [self getMMSSFromSS:current]];
                    self.AllTime.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:AllTime+1]];
                }
            }
        }];
        [self initView];
    }

    

}
- (void)playbackFinished{
    [self nextMusic];
}
-(void) initView {
    //初始化图片
    UIImage *tempImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_appDelegate.musicObj.imageUrl]]];
    _imageView.image = tempImage;
    _backgroundView.image = tempImage;
    //初始化歌曲名和歌手
    _nameLabel.text = _appDelegate.musicObj.musicName;
    _singerLabel.text = _appDelegate.musicObj.musicSinger;
    //初始化循环类型
    switch (self.appDelegate.playPattern) {
            //0代表列表循环播放
        case 0:
            self.appDelegate.playPattern = 0;
            [_playPatternButton setImage:[UIImage imageNamed:@"列表循环"] forState:UIControlStateNormal];
            break;
            //1代表单曲循环播放
        case 1:
            self.appDelegate.playPattern = 1;
            [_playPatternButton setImage:[UIImage imageNamed:@"单曲循环"] forState:UIControlStateNormal];
            break;
            //2代表随机播放
        case 2:
            self.appDelegate.playPattern = 2;
            [_playPatternButton setImage:[UIImage imageNamed:@"顺序播放"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    //初始化暂停button
    if(self.appDelegate.playState == 1) {
        //播放
        [_pauseButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }else {
        //暂停
        [_pauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
    

    //修改slider样式
    [self.musicSlider setThumbImage:[UIImage imageNamed: @"slider"] forState:UIControlStateNormal];
    //添加旋转动画
    [self addAnimationToImageView];
    if(_appDelegate.playState == 0) {
        [self pauseLayer:_imageView.layer];
        [self pausedWithAnimated:false];
    }
}
//播放音乐
-(void) playCurrentMusic {
    self.musicSlider.value =0;
    self.playedTime.text = @"00:00";
    self.AllTime.text =@"00:00";
    //添加时间观察者

    _appDelegate.timeObserve = [self.appDelegate.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float AllTime = CMTimeGetSeconds(_appDelegate.player.currentItem.duration);
        if (current) {
            self.musicSlider.value = (current / AllTime);
            if(self.musicSlider.value < 0) {
                self.playedTime.text =@"00:00";
                self.AllTime.text = @"00:00";
            }else {
                self.playedTime.text =[NSString stringWithFormat:@"%@", [self getMMSSFromSS:current]];
                self.AllTime.text = [NSString stringWithFormat:@"%@", [self getMMSSFromSS:AllTime+1]];
            }

        }
    }];

    [self.appDelegate.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:_appDelegate.player.currentItem];
    //标记播放状态
    _appDelegate.playState = 1;
    [self resumeLayer:self.imageView.layer];
    [self playedWithAnimated:YES];
    _appDelegate.playState = 1;
    [_pauseButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    
}

-(void) nextMusic {

    

    if(self.appDelegate.playPattern == 0) {
        //列表循环
        _appDelegate.musicIndex = (_appDelegate.musicIndex + 1) % [_appDelegate.musicList count];
    }
    else if(self.appDelegate.playPattern == 1) {
        //单曲循环
    }else if(self.appDelegate.playPattern == 2) {
        //随机播放
        _appDelegate.musicIndex = (arc4random()) % [_appDelegate.musicList count];
    }
    if(_appDelegate.timeObserve) {
        [_appDelegate.player removeTimeObserver:_appDelegate.timeObserve];
        _appDelegate.timeObserve = nil;
    }
    _appDelegate.musicObj = [_appDelegate.musicList objectAtIndex:_appDelegate.musicIndex];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_appDelegate.musicObj.musicUrl]];
    self.appDelegate.player = [[AVPlayer alloc] initWithPlayerItem:item];
    [self initView];
    [self playCurrentMusic];
    [self resumeLayer:self.imageView.layer];
}
-(void) preMusic {

    if(self.appDelegate.playPattern == 0) {
        //列表循环
        _appDelegate.musicIndex = (_appDelegate.musicIndex - 1) % [_appDelegate.musicList count];
    }
    else if(self.appDelegate.playPattern == 1) {
        //单曲循环
    }else if(self.appDelegate.playPattern == 2) {
        //随机播放
        _appDelegate.musicIndex = (arc4random()) % [_appDelegate.musicList count];
    }
    if(_appDelegate.timeObserve) {
        [_appDelegate.player removeTimeObserver:_appDelegate.timeObserve];
        _appDelegate.timeObserve = nil;
    }
    _appDelegate.musicObj = [_appDelegate.musicList objectAtIndex:_appDelegate.musicIndex];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:_appDelegate.musicObj.musicUrl]];
    self.appDelegate.player = [[AVPlayer alloc] initWithPlayerItem:item];
    [self initView];
    [self playCurrentMusic];
    [self resumeLayer:self.imageView.layer];
}
//秒转化为分秒
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds  = totalTime;
    

    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
    
}
//添加旋转和圆形
- (void)addAnimationToImageView {
    _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _animation.removedOnCompletion = NO;
    _animation.duration    = 30.0; // 持续时间
    _animation.repeatCount = NSIntegerMax; // 重复次数,这里设置为最大，达到不停旋转的效果
    
    // 设定旋转角度
    _animation.fromValue   = [NSNumber numberWithFloat:0.0]; // 起始角度
    _animation.toValue     = [NSNumber numberWithFloat:2 * M_PI];  // 终止角度
    
    // 添加动画
    [self.imageView.layer addAnimation:_animation
                                forKey:nil];
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}


//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //添加圆角
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.width * 0.5;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    self.imageView.layer.borderWidth = 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 通过固定layer的anchorPoint来实现定点旋转
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)playedWithAnimated:(BOOL)animated {
    [self setAnchorPoint:CGPointMake(25.0/97, 25.0/153) forView:self.needle];
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.needle.transform = CGAffineTransformIdentity;
        }];
    }else {
        self.needle.transform = CGAffineTransformIdentity;
    }
    
    _appDelegate.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animation)];
    
    // 加入到主循环中
    [_appDelegate.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// 停止音乐时
- (void)pausedWithAnimated:(BOOL)animated {
    
    [self setAnchorPoint:CGPointMake(25.0/97, 25.0/153) forView:self.needle];
    
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.needle.transform = CGAffineTransformMakeRotation(-M_PI_4);
        }];
    }else {
        self.needle.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }
    
    [_appDelegate.displayLink invalidate];
}

// 图片旋转
//- (void)animation {
//    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_4 / 100);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
