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
@interface LXDtViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *userVideoCount;
@property (weak, nonatomic) IBOutlet LXPlayerView *videoView;
@property (weak, nonatomic) IBOutlet UIScrollView *desScrollView;
@property (weak, nonatomic) IBOutlet UILabel *loveCount;
@property (weak, nonatomic) IBOutlet UILabel *talkCount;
- (IBAction)collection:(id)sender;

@end

@implementation LXDtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = YES;
        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"mp4"];
//        NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
//        AVAsset *movieAsset	= [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
//        
//        //    NSURL *sourceMovieURL = [NSURL URLWithString:self.model.video];
//        //    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:sourceMovieURL];
//        
//        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
//        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//        playerLayer.frame = self.videoView.layer.bounds;
//        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        
//        [self.videoView.layer addSublayer:playerLayer];
//        //    [self.view.layer addSublayer:playerLayer];
//        [player play];
        
        [self.videoView startPlayUrl:self.model.video];

    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.videoView stopPlayer];
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
