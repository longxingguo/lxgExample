//
//  LXGDDViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/10/17.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGDDViewController.h"
#import <MapKit/MapKit.h>
#import "LXGTableView.h"
@interface LXGDDViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)MKMapView    * mapView;
@property (nonatomic, strong)LXGTableView * tableView;
@end
@implementation LXGDDViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)viewWillLayoutSubviews{
    NSLog(@"ffff%@",NSStringFromCGRect(self.view.bounds));
}
-(void)creatUI{
    NSLog(@"hhhhhh%@",NSStringFromCGRect(self.view.bounds));
    self.mapView          = [[MKMapView alloc]init];
    self.mapView.mapType  = MKMapTypeStandard;
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //
    self.tableView                              = [[LXGTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.contentInset                 = UIEdgeInsetsMake(500, 0, 0, 0);
    self.tableView.tableHeaderView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0.001)];
    self.tableView.backgroundColor              = [UIColor clearColor];
    self.tableView.delegate                     = self;
    self.tableView.dataSource                   = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight          = 0.0;
    self.tableView.sectionFooterHeight          = 0.0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)){
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets     = NO;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    if(indexPath.row%2==0){
        cell.backgroundColor = [UIColor blueColor];
    }else{
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}
@end
