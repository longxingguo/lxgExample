//
//  LinkViewController.m
//  Notes
//
//  Created by 龙兴国 on 2020/7/10.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import "LinkViewController.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface LinkViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView    * leftTableView;
@property (strong, nonatomic) UITableView    * rightTableView;
@property (nonatomic, strong) NSMutableArray * datas;
@property (strong, nonatomic) NSIndexPath    * currentSelectIndexPath;
@end
@implementation LinkViewController
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 1; i <= 10; i++) {
            [_datas addObject:[NSString stringWithFormat:@"第%zd分区", i]];
        }
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    [self createTableView];
}
- (void)createTableView{
    self.leftTableView             = [[UITableView alloc] initWithFrame:(CGRect){0, 0, ScreenWidth * 0.25f, ScreenHeight}];
    self.rightTableView            = [[UITableView alloc] initWithFrame:(CGRect){ScreenWidth * 0.25f, 0, ScreenWidth * 0.75f, ScreenHeight}];
    self.rightTableView.delegate   = self.leftTableView.delegate = self;
    self.rightTableView.dataSource = self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.leftTableView) {
        return 1;
    }else{
        return self.datas.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.datas.count;
    }else{
        return 3;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return nil;
    }else{
        return self.datas[section];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID   = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (tableView == self.leftTableView) {
        cell.textLabel.text = self.datas[indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 第%zd行", self.datas[indexPath.section], indexPath.row + 1];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.rightTableView){
       return;
    }else{
        [self.rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:YES scrollPosition:UITableViewScrollPositionTop];
        self.currentSelectIndexPath = indexPath;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return 0;
    }else{
        return 30;
    }
}
#pragma mark - UIScrollViewDelega
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.currentSelectIndexPath) {
        return;
    }
    if ((UITableView *)scrollView == self.leftTableView) {
       return;
    }else{
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 重新选中一下当前选中的行数，不然会有bug
    if (self.currentSelectIndexPath) {
        self.currentSelectIndexPath = nil;
    }
}
@end
