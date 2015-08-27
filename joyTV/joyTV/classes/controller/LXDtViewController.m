//
//  LXDtViewController.m
//  joyTV
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXDtViewController.h"
#import "UIImageView+WebCache.h"
#import "LXUser.h"
#import "LXPlayerView.h"
#import "LXMovieModel.h"
#import "LXinformViewController.h"

#import "LXDataBaseHandle.h"

#import "MobClick.h"
#import "UMSocial.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXDtViewController ()<LXPlayerViewDelegate, UMSocialUIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userVideoCount;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet LXPlayerView *videoView;   //视频播放视图

@property (strong, nonatomic) UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *desScroll;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivity;

//转发/分享
- (IBAction)share:(id)sender;
//收藏
- (IBAction)collection:(id)sender;
- (IBAction)inform:(id)sender;

@end

@implementation LXDtViewController


-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
        [_desLabel setFont:[UIFont systemFontOfSize:15]];
    }
    return _desLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.desScroll addSubview:self.desLabel];
    self.videoView.delegate = self;
    
    self.desLabel.numberOfLines = 0;
    self.progressView.progress = 0.0;
    
    if (self.model)
    {
        //加载数据
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.model.user.avatar]];
        LXLog(@"%@", self.model.user.avatar);
        self.headerImage.layer.cornerRadius = self.headerImage.bounds.size.height/2;
        self.headerImage.layer.masksToBounds = YES;
        self.headerImage.clipsToBounds = YES;
        
        self.userTime.text = self.model.created_at;
        self.userName.text = self.model.user.screen_name;
        self.userVideoCount.text = self.model.user.be_liked_count;
        
        [self setDescText:self.model.caption];
        
        
        
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
        
        
        [self.videoView startPlayUrl:self.model.video];
        [self.view bringSubviewToFront:[self.view viewWithTag:521]];
        
        LXLog(@"%@", self.model.url);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDescText:(NSString *)text
{
    
    self.desLabel.text = text;
    self.desLabel.numberOfLines = 0;
    CGRect frame = CGRectMake(5, 0, kScreenWidth - 10, 0);
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 12, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    frame.size.height = rect.size.height;
    if (frame.size.height > 30) {
        frame.size.height += 15;
    }
    self.desLabel.frame = frame;
    LXLog(@"%.f, %.f, %.f, %.f", self.desLabel.frame.origin.x, self.desLabel.frame.origin.y, self.desLabel.frame.size.width, self.desLabel.frame.size.height);
    self.desScroll.contentSize = CGSizeMake(frame.size.width, frame.size.height);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
 
    [MobClick beginLogPageView:@"detailPage"];
}

-(void)viewWillLayoutSubviews
{
   [self setDescText:self.model.caption];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.videoView stopPlayer];
    [MobClick endLogPageView:@"detailPage"];
}

#pragma mark 将秒数转换成
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


#pragma mark 播放器代理方法
#pragma mark 结束播放执行的方法
-(void)LXPlayerViewDidEndPlay:(LXPlayerView *)playView
{
    [playView reStart];
}

#pragma mrak 播放中实时调用
-(void)LXPlayerView:(LXPlayerView *)playerView current:(CGFloat)currentSecond total:(CGFloat)totalSecond
{
    self.progressView.progress = currentSecond/totalSecond;
    
    if (currentSecond + 1.5 > totalSecond) {
        [playerView reStart];
    }
}

#pragma mark 进入缓冲状态
-(void)LXPlayerView:(LXPlayerView *)playerView loading:(CGFloat)loadProgress
{
    if (![self.myActivity isAnimating]) {
        LXLog(@"开启菊花");
        [self.myActivity startAnimating];
    }
}

#pragma mark 缓冲完毕,可以继续播放
- (void)LXPlayerView:(LXPlayerView *)playerView loaded:(CGFloat)loadProgress
{
    if ([self.myActivity isAnimating]) {
        LXLog(@"关闭菊花");
        [self.myActivity stopAnimating];
    }
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
    NSMutableString *shareString = [[NSMutableString alloc] init];
    [shareString appendString:self.model.caption];
    [shareString appendString:@"\n"];
    [shareString appendString:self.model.url];
    
    
    //友盟分享
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55b6157ee0f55a8006000d14"
                                      shareText:shareString
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent, UMShareToDouban, UMShareToRenren, nil]
                                       delegate:self];

    //友盟统计
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"collect"] = self.model.url;
    [MobClick event:@"Forward" attributes:dict];
    [MobClick event:@"Forward"];
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    [self.videoView.player pause];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        LXLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
    NSLog(@"分享结果");
    [self.videoView.player play];
}


- (IBAction)collection:(id)sender {
    
    if (![LXDataBaseHandle isCollectWithModel:self.model]) {
        if ([LXDataBaseHandle collectWithMovieModel:self.model]) {
            LXLog(@"收藏成功");
            
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
            
            //友盟统计
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            dict[@"collect"] = self.model.url;
            [MobClick event:@"collect" attributes:dict];
            
            [MobClick event:@"collect"];
        }
        else
        {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"收藏失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
            LXLog(@"收藏失败");
        }
    }
    else
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:@"已经收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
        LXLog(@"已经收藏了");
    }
    
}

- (IBAction)inform:(id)sender {
    
    //进入举报页面
    [self.videoView.player pause];
    
    LXinformViewController *informVC = [[LXinformViewController alloc] init];
    [self.navigationController pushViewController:informVC animated:YES];
    
}
@end
