//
//  LXHotCollectView.h
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXMovieModel.h"


@class LXHotCollectView;
@protocol LXHotCollectViewDelegate <NSObject>

- (void)LXHotCollectView:(LXHotCollectView *)collectView didSelectIndexPath:(NSIndexPath *)indexPath movieModel:(LXMovieModel *)movieModel;

@end

@interface LXHotCollectView : UIView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *dataUrl;
@property (nonatomic, assign) id<LXHotCollectViewDelegate> delegate;

- (void)refresh;

@end
