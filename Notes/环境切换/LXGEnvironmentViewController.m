//
//  LXGEnvironmentViewController.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGEnvironmentViewController.h"
@interface LXGEnvironmentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * environmentTableView;
@property (nonatomic, strong) NSArray     * environmentArray;
@end
@implementation LXGEnvironmentViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title             = @"环境切换";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
    [self.view addSubview:self.environmentTableView];
}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.environmentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EnvironmentTableViewCell"];
    cell.textLabel.text    = self.environmentArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [LXGPublicTool alert:[NSString stringWithFormat:@"确定更换到%@",self.environmentArray[indexPath.row]] andSure:^{
        [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"EnvironmentNumber"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableView *)environmentTableView{
    if (!_environmentTableView) {
        _environmentTableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _environmentTableView.delegate        = self;
        _environmentTableView.dataSource      = self;
        _environmentTableView.tableFooterView = [UIView new];
        [_environmentTableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"EnvironmentTableViewCell"];
    }
    return _environmentTableView;
}
-(NSArray *)environmentArray{
    if (!_environmentArray){
        _environmentArray = @[@"正式环境",@"测试环境",@"开发环境"];
    }
    return _environmentArray;
}
@end
