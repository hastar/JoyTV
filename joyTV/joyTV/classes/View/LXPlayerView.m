//
//  LXPlayerView.m
//  joyTV
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXPlayerView.h"
#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>


@interface LXPlayerView () {
    BOOL _played;
    NSString *_totalTime;
    NSDateFormatter *_dateFormatter;
}

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) id playbackTimeObserver;


@end

@implementation LXPlayerView


- (void)startPlayUrl:(NSString *)videoUrl
{
    NSURL *url = [NSURL URLWithString:videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.layer addSublayer:playerLayer];
    
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
}

-(void)stopPlayer
{    
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.player removeTimeObserver:self.playbackTimeObserver];
    [self.player pause];
}


- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
        NSString *timeString = [weakSelf convertTime:currentSecond];
        NSLog(@"current time is %@/%@",timeString,_totalTime);
        
        if (!self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerView:current:total:)]) {
            [self.delegate LXPlayerView:self current:currentSecond total:totalSecond];
        }
        
    }];
}

// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            
            
            if (!self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewWillStartPlay:)]) {
                [self.delegate LXPlayerViewWillStartPlay:self];
            }
            [self.player play];
            
            if (!self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewDidStartPlay:)]) {
                [self.delegate LXPlayerViewDidStartPlay:self];
            }
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
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
    NSLog(@"Play end");
    
    if (!self.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewWillEndPlay:)]) {
        [self.delegate LXPlayerViewWillEndPlay:self];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        NSLog(@"已经播放到末尾了");
       
        [weakSelf.player pause];
        if (!weakSelf.delegate && [self.delegate respondsToSelector:@selector(LXPlayerViewDidEndPlay:)]) {
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
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self.player removeTimeObserver:self.playbackTimeObserver];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
