//
//  LXGFlowLayoutViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGFlowLayoutViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#define iwidth    floor((self.view.frame.size.width - 11 * 8)/10.0)//根据最大数量算大小
#define ihight    40
#define ispec     8
#import "HorizontalLayout.h"
#import "LXGCollectionViewHorizontalLayout.h"
@interface LicensecViewCell : UICollectionViewCell
@property (nonatomic ,strong)UILabel  * lableLicensePlate;
@end
@implementation LicensecViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor     = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 5;
        self.lableLicensePlate               = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.contentView.frame.size.width, self.contentView.frame.size.height)];
        self.lableLicensePlate.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lableLicensePlate];
    }
    return self;
}
@end
@interface LXGFlowLayoutViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong)UICollectionView * numberCollectionView;
@property (nonatomic ,strong)NSMutableArray   * numberdataarray;
//
@property (nonatomic ,strong)UICollectionView * pageCollectionView;
@end

@implementation LXGFlowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UICollectionViewFlowLayout * nmlayout  = [[UICollectionViewFlowLayout alloc] init];
    nmlayout.itemSize                      = CGSizeMake(iwidth,ihight);
    self.numberCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100,self.view.frame.size.width,200) collectionViewLayout:nmlayout];
    self.numberCollectionView.delegate     = self;
    self.numberCollectionView.dataSource   = self;
    self.numberCollectionView.showsVerticalScrollIndicator   = NO;
    self.numberCollectionView.showsHorizontalScrollIndicator = NO;
    self.numberCollectionView.delaysContentTouches           = false;
    self.numberCollectionView.backgroundColor                = [UIColor greenColor];
    [self.numberCollectionView   registerClass:[LicensecViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LicensecViewCell class])];
    [self.view addSubview:self.numberCollectionView];
//    if (@available(iOS 11.0, *)) {
//        self.numberCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
    self.numberCollectionView.userInteractionEnabled = YES;
    [self.numberCollectionView addGestureRecognizer:longPressGesture];
    
    
    
    //
    //UICollectionViewFlowLayout * pageFlowLayout    = [[UICollectionViewFlowLayout alloc] init];
    //HorizontalLayout * pageFlowLayout           = [[HorizontalLayout alloc]init];
    //pageFlowLayout.itemCountPerRow              = 7;
    //pageFlowLayout.rowCount                     = 3;
    LXGCollectionViewHorizontalLayout * pageFlowLayout = [[LXGCollectionViewHorizontalLayout alloc]initWithItemCountPerRow:7 maxRowCount:2];
    pageFlowLayout.scrollDirection              = UICollectionViewScrollDirectionHorizontal;
    self.pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 400,self.view.frame.size.width-20,60) collectionViewLayout:pageFlowLayout];
    self.pageCollectionView.delegate     = self;
    self.pageCollectionView.dataSource   = self;
    self.pageCollectionView.showsVerticalScrollIndicator   = NO;
    self.pageCollectionView.showsHorizontalScrollIndicator = NO;
    self.pageCollectionView.pagingEnabled                  = YES;
    self.pageCollectionView.backgroundColor              = [UIColor greenColor];
    [self.pageCollectionView   registerClass:[LicensecViewCell class] forCellWithReuseIdentifier:@"page"];
    [self.view addSubview:self.pageCollectionView];
}
- (void)moveAction:(UILongPressGestureRecognizer *)longGes {
    if (longGes.state == UIGestureRecognizerStateBegan){
        NSIndexPath * selectPath = [self.numberCollectionView indexPathForItemAtPoint:[longGes locationInView:longGes.view]];
        [self.numberCollectionView beginInteractiveMovementForItemAtIndexPath:selectPath];
    }else if (longGes.state == UIGestureRecognizerStateChanged) {
        [self.numberCollectionView updateInteractiveMovementTargetPosition:[longGes locationInView:longGes.view]];
    }else if (longGes.state == UIGestureRecognizerStateEnded) {
        [self.numberCollectionView endInteractiveMovement];
    }else {
        [self.numberCollectionView cancelInteractiveMovement];
    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray * sourcearr = self.numberdataarray[sourceIndexPath.section];
    id obj                     = sourcearr[sourceIndexPath.item];
    [sourcearr removeObjectAtIndex:sourceIndexPath.item];
    NSMutableArray * destinationarr = self.numberdataarray[destinationIndexPath.section];
    [destinationarr insertObject:obj atIndex:destinationIndexPath.item];
    [self.numberCollectionView reloadData];
}
#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(collectionView == self.numberCollectionView){
        return self.numberdataarray.count;
    }else{
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == self.numberCollectionView){
        NSArray * itemarr = self.numberdataarray[section];
        return itemarr.count;
    }else{
        return 28;//必须是行列积的整数倍
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.numberCollectionView){
        LicensecViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LicensecViewCell class])forIndexPath:indexPath];
        NSArray * itemarr           = self.numberdataarray[indexPath.section];
        cell.lableLicensePlate.text = itemarr[indexPath.item];
        return cell;
    }else{
        LicensecViewCell * cell     = [collectionView dequeueReusableCellWithReuseIdentifier:@"page"forIndexPath:indexPath];
        if(indexPath.item>21){
            cell.lableLicensePlate.text = @"只有22个";
        }else{
            //取22个数据填充
            cell.lableLicensePlate.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        }
        return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(collectionView == self.numberCollectionView){
        return CGSizeMake(self.view.frame.size.width, ispec);
    }else{
        return CGSizeMake(0, 0);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.numberCollectionView){
        return CGSizeMake(iwidth,ihight);
    }else{
//        return CGSizeMake(floor((self.view.frame.size.width-20)/7.0), 30);
        return CGSizeMake(((self.view.frame.size.width-20)/7.0), 30);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if(collectionView == self.numberCollectionView){
        return ispec;
    }else{
        return 0;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{//最关键的东西 因为我分组了的问题  调整每个分组UICollectionView左右边距  如果只有一个组 使用默认的不必实现这个方法 我就只想看看效果而已
    if(collectionView == self.numberCollectionView){
        NSArray * itemarr = self.numberdataarray[section];
        UIEdgeInsets ins  = UIEdgeInsetsMake(0,(self.view.frame.size.width - (itemarr.count * iwidth)  - (itemarr.count - 1) * ispec)/2.0, 0, (self.view.frame.size.width - (itemarr.count * iwidth)  - (itemarr.count - 1) * ispec)/2.0);
        return ins;
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
-(NSMutableArray *)numberdataarray{
    if(!_numberdataarray){
        _numberdataarray = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0", nil],[NSMutableArray arrayWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P", nil],[NSMutableArray arrayWithObjects:@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L", nil],[NSMutableArray arrayWithObjects:@"Z",@"X",@"C",@"V",@"B",@"N",@"M", nil], nil];
    }
    return _numberdataarray;
}
@end
