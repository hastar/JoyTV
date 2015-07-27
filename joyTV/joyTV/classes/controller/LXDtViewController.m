//
//  LXDtViewController.m
//  joyTV
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXDtViewController.h"
#import "UIImageView+WebCache.h"
#import "LXUser.h"
#import "LXPlayerView.h"
#import "LXMovieModel.h"

#import <AVFoundation/AVFoundation.h>
@interface LXDtViewController ()<LXPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userVideoCount;
@property (weak, nonatomic) IBOutlet LXPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UIScrollView *desScrollView;
@property (weak, nonatomic) IBOutlet UILabel *loveCount;
@property (weak, nonatomic) IBOutlet UILabel *talkCount;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

- (IBAction)collection:(id)sender;

@end

@implementation LXDtViewController

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, [UIScreen mainScreen].bounds.size.width - 10, 0)];
    }
    
    return _desLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoView.delegate = self;
    self.desScrollView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.98];
    
    self.desLabel.numberOfLines = 0;
//    self.desLabel.backgroundColor = [UIColor cyanColor];
    [self.desScrollView addSubview:self.desLabel];
    self.desScrollView.contentSize = CGSizeMake(self.desLabel.bounds.size.width, self.desLabel.bounds.size.height);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDescText:(NSString *)text
{
    self.desLabel.text = text;
    CGRect frame = self.desLabel.frame;
    CGFloat width = frame.size.width;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    frame.size.height = rect.size.height;
    if (frame.size.height > 30) {
        frame.size.height += 15;
    }
    self.desLabel.frame = frame;
    self.desScrollView.contentSize = CGSizeMake(frame.size.width-2, frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.model) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.user.avatar]];
        NSLog(@"%@", self.model.user.avatar);
        self.headerImage.layer.cornerRadius = self.headerImage.bounds.size.height/2;
        self.headerImage.layer.masksToBounds = YES;
        self.headerImage.clipsToBounds = YES;
        
        self.userName.text = self.model.user.screen_name;
        self.userTime.text = self.model.created_at;
        self.userVideoCount.text = self.model.user.be_liked_count;
        
        [self setDescText:self.model.caption];
        
        
        
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
        
        
        [self.videoView startPlayUrl:self.model.video];

    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.videoView stopPlayer];
}


-(void)LXPlayerView:(LXPlayerView *)playerView current:(CGFloat)currentSecond total:(CGFloat)totalSecond
{
    NSString *currentTime = [self convertTime:currentSecond];
    NSString *totalTime = [self convertTime:totalSecond];
    NSLog(@"current time is %@/%@", currentTime, totalTime);
}


- (NSString *)convertTime:(CGFloat)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [dateFormatter stringFromDate:d];
    return showtimeNew;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)collection:(id)sender {
}
@end
