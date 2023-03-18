//
//  LinkViewController2.m
//  Notes
//
//  Created by 龙兴国 on 2020/7/10.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import "LinkViewController2.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface LinkViewController2 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,assign) NSInteger        selectIndex;
@property (nonatomic,assign) BOOL             isScrollDown;
@property (nonatomic,strong) UITableView    * leftTableView;
@property (nonatomic,strong) UITableView    * rightTableView;
@property (nonatomic,strong) NSMutableArray * datas;
@end
@implementation LinkViewController2
-(NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
        for (NSInteger i = 1; i <= 20; i++) {
            [_datas addObject:[NSString stringWithFormat:@"第%zd分区", i]];
        }
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.selectIndex         = 0;
    self.isScrollDown        = YES;
    [self creatUI];
}
-(void)creatUI{
    self.leftTableView             = [[UITableView alloc] initWithFrame:(CGRect){0, 0, ScreenWidth * 0.25f, ScreenHeight}];
    self.rightTableView            = [[UITableView alloc] initWithFrame:(CGRect){ScreenWidth * 0.25f, 0, ScreenWidth * 0.75f, ScreenHeight}];
    self.rightTableView.delegate   = self.leftTableView.delegate  = self;
    self.rightTableView.dataSource = self.leftTableView.dataSource = self;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
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
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section{
    // RightTableView滚动的方向向上，（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((self.rightTableView == tableView)&& !self.isScrollDown && (self.rightTableView.dragging || self.rightTableView.decelerating)){
        [self selectRowAtIndexPath:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    // RightTableView滚动的方向向下，（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((self.rightTableView == tableView)&& self.isScrollDown && (self.rightTableView.dragging || self.rightTableView.decelerating)){
        [self selectRowAtIndexPath:section + 1];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (self.leftTableView == tableView){
        self.selectIndex = indexPath.row;
        [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}
// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index{
    NSIndexPath * IndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.leftTableView selectRowAtIndexPath:IndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}
#pragma mark - UISrcollViewDelegate
//标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    static CGFloat lastY   = 0;
    UITableView *tableView = (UITableView *) scrollView;
    if (self.rightTableView== tableView){
        NSLog(@"%@ %@   %f",NSStringFromCGRect(self.rightTableView.frame),NSStringFromCGRect(self.rightTableView.bounds),scrollView.contentOffset.y);
        self.isScrollDown  = lastY < scrollView.contentOffset.y;
        lastY              = scrollView.contentOffset.y;
    }
}
@end
//frame左上角相对于bounds左上角的位移  bounds.origin
