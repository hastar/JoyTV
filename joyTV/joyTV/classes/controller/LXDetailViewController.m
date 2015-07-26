//
//  LXDetailViewController.m
//  joyTV
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "LXDetailViewController.h"

@interface LXDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation LXDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    NSLog(@"url = %@", self.url);
    if (self.url != nil) {
        NSURL *myUrl = [NSURL URLWithString:self.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:myUrl];
        [self.webView loadRequest:request];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
