//
//  LXOwnerViewController.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXOwnerViewController.h"
#import "LXDataBaseHandle.h"
#import "LXCollectViewController.h"
#import "SDImageCache.h"
#import "LXAboutViewController.h"
#import "LXEmailViewController.h"
#import <MessageUI/MessageUI.h>

#define LXColor(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

@interface LXOwnerViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LXOwnerViewController


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"我的收藏",@"清空缓存", @"关于我们", @"反馈", nil];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = LXColor(253.0/255, 189.0/255, 10.0/255, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:LXColor(253.0/255, 189.0/255, 10.0/255, 1.0)}];

    [self.view addSubview:self.tableView];
    
    
}

#pragma mark tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSArray *array = [LXDataBaseHandle arrayWithAllModel];
            LXCollectViewController *collectVC = [[LXCollectViewController alloc] init];
            collectVC.modelArray = array;
            [self.navigationController pushViewController:collectVC animated:YES];
            
            break;
        }
        case 1:
        {
            NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
            CGFloat size;
            NSString *mete;
            if (cacheSize > 1024 * 1024) {
                size = cacheSize * 1.0 / 1000 / 1000;
                mete = @"M";
            }
            else
            {
                size = cacheSize * 1.0 / 1000;
                mete = @"K";
            }
            
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] cleanDisk];
            
            NSString *str = [NSString stringWithFormat:@"已清空 %.2f%@ 缓存", size, mete];
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
            break;
        }
        case 2:
        {
            LXAboutViewController *aboutVC = [[LXAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
        case 3:
        {
//            LXEmailViewController *emailVc = [[LXEmailViewController alloc] init];
//            [self.navigationController pushViewController:emailVc animated:YES];
            
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                [self sendEmailAction]; // 调用发送邮件的代码
            }
        }
            
        default:
            break;
    }
}


- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"反馈"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"hastarliu@gmail.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];

    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            LXLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            LXLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            LXLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            LXLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
