//
//  LXHotCollectionViewCell.m
//  joyTV
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXHotCollectionViewCell.h"

@implementation LXHotCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    //圆形头像
    self.userImageView.layer.cornerRadius = 20;
    self.userImageView.layer.borderWidth = 2;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.masksToBounds = YES;
}


@end
