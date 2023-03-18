//
//  LXGRollingView.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGRollingView.h"
#import <Masonry/Masonry.h>
#define SMKMaxSections 3
@interface LXGRollingTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIImageView * image;
@property (nonatomic ,strong)UILabel     * lable;
@end
@implementation LXGRollingTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@(20));
    }];
    self.lable = [[UILabel alloc]init];
    [self.contentView addSubview:self.lable];
    [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
@interface LXGRollingView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSTimer     * timer;
@end
@implementation LXGRollingView
-(void)dealloc{
    NSLog(@"");
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self addSubview:self.tableView];
    }
    return self;
}
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    if (titleArray == nil){
        [self removeTimer];
        return;
    }
    if (titleArray.count == 1){
        [self removeTimer];
    }
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SMKMaxSections / 2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self addTimer];
}
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)addTimer{
    self.timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)nextPage{
    // 1.马上显示回最中间那组的数据
    NSIndexPath * currentIndexPathReset = [self resetIndexPath];
    // 2.计算出下一个需要展示的位置
    NSInteger nextItem    = currentIndexPathReset.row + 1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem == self.titleArray.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath * nextIndexPath = [NSIndexPath indexPathForRow:nextItem inSection:nextSection];
    // 3.通过动画滚动到下一个位置
    [self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (NSIndexPath *)resetIndexPath{
    // 当前正在展示的位置
    NSIndexPath * currentIndexPath      = [[self.tableView indexPathsForVisibleRows] lastObject];
    // 马上显示回最中间那组的数据
    NSIndexPath * currentIndexPathReset = [NSIndexPath indexPathForRow:currentIndexPath.row inSection:SMKMaxSections/2];
    [self.tableView scrollToRowAtIndexPath:currentIndexPathReset atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    return currentIndexPathReset;
}
- (void)setIsCanScroll:(BOOL)isCanScroll {
    _isCanScroll                 = isCanScroll;
    self.tableView.scrollEnabled = isCanScroll;
}
#pragma mark --------------------  UITableView DataSource && Delegate  --------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SMKMaxSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXGRollingTableViewCell * cell   = [tableView dequeueReusableCellWithIdentifier:@"LXGRollingTableViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.backgroundColor;
    cell.lable.textColor             = self.titleColor;
    cell.lable.font                  = self.titleFont;
    cell.lable.text                  = self.titleArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedBlock ? self.selectedBlock(indexPath.row, self.titleArray[indexPath.row]) : nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.bounds.size.height;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
- (UITableView *)tableView{
    if (!_tableView){
        _tableView                                = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _tableView.delegate                       = self;
        _tableView.dataSource                     = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator   = NO;
        _tableView.scrollEnabled                  = NO;
        _tableView.pagingEnabled                  = YES;
        _tableView.estimatedRowHeight             = 0;//增加下面三句（高度预算），解决scrollToRowAtIndexPath 滚动到指定位置偏差不准确问题
        _tableView.estimatedSectionFooterHeight   = 0;
        _tableView.estimatedSectionHeaderHeight   = 0;
        [_tableView registerClass:[LXGRollingTableViewCell class] forCellReuseIdentifier:@"LXGRollingTableViewCell"];
    }
    return _tableView;
}
@end
