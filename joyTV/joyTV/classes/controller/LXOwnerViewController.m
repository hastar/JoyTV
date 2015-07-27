//
//  LXOwnerViewController.m
//  joyTV
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 hastar. All rights reserved.
//


#import "LXOwnerViewController.h"


#define LXColor(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

@interface LXOwnerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

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
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    
    return cell;
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
