//
//  LXPlayerView.h
//  joyTV
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXPlayerView;
@protocol LXPlayerViewDelegate <NSObject>

- (void)LXPlayerView:(LXPlayerView *)playerView current:(CGFloat)currentSecond total:(CGFloat)totalSecond;

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

@property (nonatomic, assign) id<LXPlayerViewDelegate> delegate;

- (void)startPlayUrl:(NSString *)videoUrl;

- (void)stopPlayer;

@end
