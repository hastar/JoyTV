//
//  LXPlayerView.h
//  joyTV
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class LXPlayerView;
@protocol LXPlayerViewDelegate <NSObject>

@optional

/**
 *  播放进度实时控制
 *
 *  @param playerView    playerView
 *  @param currentSecond 当前播放到第几秒
 *  @param totalSecond   总共有多少秒
 */
- (void)LXPlayerView:(LXPlayerView *)playerView current:(CGFloat)currentSecond total:(CGFloat)totalSecond;

/**
 *  开始播放
 *
 *  @param playerView  当前对象
 *  @param totalSecond 总共多少秒
 */
- (void)LXPlayerView:(LXPlayerView *)playerView readyTototalSecond:(CGFloat)totalSecond;

/**
 *  缓冲数据不足
 *
 *  @param playerView   当前playerView
 *  @param loadProgress 当前缓冲进度
 */
- (void)LXPlayerView:(LXPlayerView *)playerView loading:(CGFloat)loadProgress;

/**
 *  数据再次缓冲好乐
 *
 *  @param playerView   当前playerView
 *  @param loadProgress 当前缓冲进度
 */
- (void)LXPlayerView:(LXPlayerView *)playerView loaded:(CGFloat)loadProgress;


#pragma mark 即将开始播放
- (void)LXPlayerViewWillStartPlay:(LXPlayerView *)playerView;
#pragma mark 已经开始播放
- (void)LXPlayerViewDidStartPlay:(LXPlayerView *)playerView;


#pragma mark 即将结束播放
- (void)LXPlayerViewDidEndPlay:(LXPlayerView *)playView;
#pragma mark 已经结束播放
- (void)LXPlayerViewWillEndPlay:(LXPlayerView *)playView;

@end


@interface LXPlayerView : UIView

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic, assign) id<LXPlayerViewDelegate> delegate;

/**
 *  开始播放指定URL视频
 *
 *  @param videoUrl 视频URL地址
 */
- (void)startPlayUrl:(NSString *)videoUrl;

/**
 *  重新播放
 */
- (void)reStart;

/**
 *  停止播放
 */
- (void)stopPlayer;

@end
