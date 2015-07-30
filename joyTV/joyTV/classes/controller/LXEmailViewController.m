//
//  LXEmailViewController.m
//  joyTV
//
//  Created by lanou on 15/7/30.
//  Copyright (c) 2015年 hastar. All rights reserved.
//
#ifdef DEBUG
#define LXLog(...) NSLog(__VA_ARGS__)
#else
#define LXLog(...)
#endif

#import "LXEmailViewController.h"
#import <MessageUI/MessageUI.h>


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface LXEmailViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *linkField;

@end

@implementation LXEmailViewController


-(UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(5, 5, kScreenWidth - 10, kScreenWidth / 4 * 3); // 设置位置
        _textView.backgroundColor = [UIColor whiteColor]; // 设置背景色
        _textView.alpha = 1.0; // 设置透明度
        _textView.text = @"请输入反馈内容"; // 设置文字
//        _textView.textAlignment = NSTextAlignmentCenter; // 设置字体对其方式
//        _textView.font = [UIFont boldSystemFontOfSize:25.5f]; // 设置字体大小
//        _textView.textColor = [UIColor redColor]; // 设置文字颜色
        [_textView setEditable:YES]; // 设置时候可以编辑
        _textView.dataDetectorTypes = UIDataDetectorTypeAll; // 显示数据类型的连接模式（如电话号码、网址、地址等）
//        _textView.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
//        _textView.returnKeyType = UIReturnKeySearch; // 设置键盘上returen键的类型
        _textView.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.clipsToBounds = YES;
    }
    
    return _textView;
}

-(UITextField *)linkField
{
    if (!_linkField) {
        _linkField = [[UITextField alloc] initWithFrame:CGRectMake(5, kScreenWidth / 4 * 3 + 30, kScreenWidth - 10, 30)];
        _linkField.placeholder = @"请输入联系方式";
        [_linkField setFont:[UIFont systemFontOfSize:13]];
        
        
        _linkField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _linkField.layer.borderWidth = 1;
        _linkField.layer.cornerRadius = 3;
        _linkField.layer.masksToBounds = YES;
        _linkField.clipsToBounds = YES;
    }
    
    return _linkField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.linkField];
    [self.view addSubview:self.textView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    
}

-(void)cancel:(id)sender
{
    
}

-(void)send:(id)sender
{
    if (self.textView.text.length == 0 ||
        self.linkField.text.length == 0) {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"反馈内容和联系方式不能为空" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alterView show];
    }
    else
    {
        if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
            [self sendEmailAction]; // 调用发送邮件的代码
        }
    }
}
- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"hastarliu@gmail.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    UIImage *image = [UIImage imageNamed:@"image"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSData *pdf = [NSData dataWithContentsOfFile:file];
    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
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


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
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
