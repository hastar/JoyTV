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

#import "UMSocial.h"
#import <AVFoundation/AVFoundation.h>
@interface LXDtViewController ()<LXPlayerViewDelegate, UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userVideoCount;
@property (weak, nonatomic) IBOutlet LXPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *loveCount;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

//转发/分享
- (IBAction)share:(id)sender;
//收藏
- (IBAction)collection:(id)sender;

@end

@implementation LXDtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoView.delegate = self;
    
    self.desLabel.numberOfLines = 0;
    self.progressView.progress = 0.0;
    
    if (self.model) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.user.avatar]];
        NSLog(@"%@", self.model.user.avatar);
        self.headerImage.layer.cornerRadius = self.headerImage.bounds.size.height/2;
        self.headerImage.layer.masksToBounds = YES;
        self.headerImage.clipsToBounds = YES;
        
        self.userName.text = self.model.user.screen_name;
        self.userTime.text = self.model.created_at;
        self.userVideoCount.text = self.model.user.be_liked_count;
        
        self.loveCount.text = self.model.likes_count;
        [self setDescText:self.model.caption];
        
        
        
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
        
        
        [self.videoView startPlayUrl:self.model.video];
        
        [self.view bringSubviewToFront:[self.view viewWithTag:521]];
    }
    
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
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.videoView stopPlayer];
}

-(void)LXPlayerViewDidEndPlay:(LXPlayerView *)playView
{
    [playView reStart];
}


-(void)LXPlayerView:(LXPlayerView *)playerView current:(CGFloat)currentSecond total:(CGFloat)totalSecond
{
    NSString *currentTime = [self convertTime:currentSecond];
    NSString *totalTime = [self convertTime:totalSecond];
    NSLog(@"current time is %@/%@", currentTime, totalTime);
    self.currentTime.text = currentTime;
    self.totalTime.text = totalTime;
    self.progressView.progress = currentSecond/totalSecond;
    
    if (currentSecond + 1.5 > totalSecond) {
        [playerView reStart];
    }
    
    
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

- (IBAction)share:(id)sender {
    
    [self.videoView.player pause];
    NSMutableString *shareString = [[NSMutableString alloc] init];
    [shareString appendString:self.model.caption];
    [shareString appendString:@"\n"];
    [shareString appendString:self.model.url];
    
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:shareString
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:self];

//    [self.videoView reStart];
    
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    
    [self.videoView.player play];
}


- (IBAction)collection:(id)sender {
}
@end
