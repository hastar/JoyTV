//
//  LXPlayerView.m
//  joyTV
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXPlayerView.h"
#import "PlayerView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXPlayerView () {
    BOOL _played;
    NSString *_totalTime;
    NSTimeInterval _currentLoadTime;
    NSDateFormatter *_dateFormatter;
}


@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) id playbackTimeObserver;
@property (nonatomic, strong) UIActivityIndicatorView *myActivity;


@end

@implementation LXPlayerView


- (UIActivityIndicatorView *)myActivity
{
    if (!_myActivity) {
        _myActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    return _myActivity;
}


- (void)reStart
{
    if (self.player) {
        [self.player pause];
        
        __block typeof(self) weakSelf = self;
        [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            
            [weakSelf.player play];
            
        }];
        
        
    }
}

- (void)startPlayUrl:(NSString *)videoUrl
{
    if ([self.subviews containsObject:self.myActivity]) {
        [self.myActivity removeFromSuperview];
    }
    [self addSubview:self.myActivity];
    
    
    
    NSURL *url = [NSURL URLWithString:videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    //监听视频的播放状态
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    LXLog(@"%.f----------------------", self.layer.bounds.size.width);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.layer addSublayer:playerLayer];
    LXLog(@"%.f, %.f, %.f, %.f", playerLayer.frame.origin.x, playerLayer.frame.origin.y, playerLayer.frame.size.width, playerLayer.frame.size.height);
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

-(void)stopPlayer
{
    [self.player pause];
}


- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
        
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(LXPlayerView:current:total:)]) {
            [weakSelf.delegate LXPlayerView:weakSelf current:currentSecond total:totalSecond];
        }
        
    }];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            LXLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            LXLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            
            //数据读取完毕，可以播放
            if (self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewWillStartPlay:)]) {
                [self.delegate LXPlayerView:self readyTototalSecond:totalSecond];
            }
            
            //即将播放
            if (self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewWillStartPlay:)]) {
                [self.delegate LXPlayerViewWillStartPlay:self];
            }
            
            //播放
            [self.player play];
            
            //已经播放
            if (self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewDidStartPlay:)]) {
                [self.delegate LXPlayerViewDidStartPlay:self];
            }
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            LXLog(@"AVPlayerStatusFailed");
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        _currentLoadTime = [self availableDuration];// 计算缓冲进度
        LXLog(@"Time Interval:%f",_currentLoadTime);
        CMTime duration = _playerItem.duration;
        CMTime current = _playerItem.currentTime;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat currentTime = CMTimeGetSeconds(current);
        LXLog(@"----------------当前缓存进度%.f, ---------%.f/%.f", _currentLoadTime, currentTime, totalDuration);
        
        if (_currentLoadTime > currentTime+2 && self.player.rate == 0) {
            self.player.rate = 1;
            LXLog(@"----------播  放 ------------");
            if (self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerView:loaded:)]) {
                [self.delegate LXPlayerView:self loaded:_currentLoadTime];
            }
        }
    }
    
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


- (void)moviePlayDidEnd:(NSNotification *)notification {
    LXLog(@"Play end");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewWillEndPlay:)]) {
        [self.delegate LXPlayerViewWillEndPlay:self];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        LXLog(@"已经播放到末尾了");
       
        [weakSelf.player pause];
        if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewDidEndPlay:)]) {
            [weakSelf.delegate LXPlayerViewDidEndPlay:self];
        }
        
    }];
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)dealloc {
    
    self.delegate = nil;
    [self.player pause];
    
    LXLog(@"已经释放了");
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    [self.player removeObserver:self forKeyPath:@"rate"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
