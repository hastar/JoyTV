//
//  LXinformViewController.m
//  joyTV
//
//  Created by lanou on 15/8/12.
//  Copyright (c) 2015年 hastar. All rights reserved.
//

#import "UMFeedback.h"
#import "LXinformViewController.h"

@interface LXinformViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation LXinformViewController


-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] initWithObjects:@"色情", @"暴力", @"诈骗", @"侵权",@"垃圾广告",@"敏感资讯", nil];
    }
    return _dataArray;
}


-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    
    [self.view addSubview:self.tableView];
    
}

-(void)send:(id)sender
{
    NSMutableString *str = [[NSMutableString alloc] init];
    for (NSString *s in self.selectArray) {
        [str appendString:s];
    }
    
    NSDictionary *dict = @{@"content":str};
    
    [[UMFeedback sharedInstance] post:dict completion:^(NSError *error) {
        if (!error) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"发送成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alterView show];
        }
        else
        {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alterView show];
        }
    }];
    
    
    NSLog(@"发送举报内容");
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section];
    
    return cell;
}

#pragma mark 返回区头尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *str = self.dataArray[indexPath.section];
    if ([self.selectArray containsObject:str]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArray removeObject:str];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArray addObject:str];
    }
    
    
}



#pragma mark 视频出现与消失时处理
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
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
