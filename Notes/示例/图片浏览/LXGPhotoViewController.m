//
//  LXGPhotoViewController.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGPhotoViewController.h"
#import "LXGPhotoCollectionViewCell.h"
#import "LXGPhotoManger.h"
#import "LXGPhotoModel.h"
@interface LXGPhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 确定按钮
@property (nonatomic, strong) UIButton *confirmButton;
/// 相册列表
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@end

@implementation LXGPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
#pragma mark - 设置控制器
-(void)creatUI {
    self.view.backgroundColor              = [UIColor whiteColor];
    self.navigationItem.title              = @"图库";
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    [self.view addSubview:self.photoCollectionView];
    //选择数量改变回调
    [[LXGPhotoManger standardPhotoManger].photoModelList  removeAllObjects];
    __weak typeof(self) weakSelf = self;
    [LXGPhotoManger standardPhotoManger].choiceCountChange = ^(NSInteger choiceCount) {
        weakSelf.confirmButton.enabled = choiceCount != 0;
        if (choiceCount == 0) {
            [weakSelf.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [weakSelf.confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } else {
            [weakSelf.confirmButton setTitle:[NSString stringWithFormat:@"确定%ld/%ld", (long)[LXGPhotoManger standardPhotoManger].choiceCount, (long)[LXGPhotoManger standardPhotoManger].maxCount] forState:UIControlStateNormal];
            [weakSelf.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    };
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.assets.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LXGPhotoCollectionViewCell class]) forIndexPath:indexPath];
    cell.row        = indexPath.row;
    cell.asset      = self.model.assets[indexPath.row];
    [cell loadImage:indexPath];
    cell.isSelect   = [self.model.selectRows containsObject:@(indexPath.row)];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.selectPhotoAction = ^(PHAsset *asset) {
        BOOL isReloadCollectionView = NO;
        if ([weakSelf.model.selectRows containsObject:@(indexPath.row)]) {
            [weakSelf.model.selectRows removeObject:@(indexPath.row)];
            [LXGPhotoManger standardPhotoManger].choiceCount--;
            isReloadCollectionView = [LXGPhotoManger standardPhotoManger].choiceCount == 9;
        } else {
            if ([LXGPhotoManger standardPhotoManger].maxCount == [LXGPhotoManger standardPhotoManger].choiceCount) {
                return;
            }
            [weakSelf.model.selectRows addObject:@(indexPath.row)];
            [LXGPhotoManger standardPhotoManger].choiceCount++;
            isReloadCollectionView = [LXGPhotoManger standardPhotoManger].choiceCount == 10;
        }
        if (isReloadCollectionView) {
            [weakSelf.photoCollectionView reloadData];
        } else {
            weakCell.isSelect = [weakSelf.model.selectRows containsObject:@(indexPath.row)];
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 20.f) / 3.f, (self.view.frame.size.width - 20.f) / 3.f);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}
#pragma mark - Get方法
-(UICollectionView *)photoCollectionView {
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
        _photoCollectionView               = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _photoCollectionView.delegate             = self;
        _photoCollectionView.dataSource           = self;
        _photoCollectionView.backgroundColor      = [UIColor whiteColor];
        _photoCollectionView.scrollEnabled        = YES;
        _photoCollectionView.alwaysBounceVertical = YES;
        [_photoCollectionView registerClass:[LXGPhotoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LXGPhotoCollectionViewCell class])];
        [self.view addSubview:_photoCollectionView];
    }
    return _photoCollectionView;
}
//确定
-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
        _confirmButton.frame = CGRectMake(0, 0, 80, 45);
        _confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    return _confirmButton;
}
-(void)confirmAction:(UIButton *)button{
    if ([LXGPhotoManger standardPhotoManger].choiceCount > 0) {
        if (self.sureSelect) {
            self.sureSelect();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//取消
-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 50, 50);
        [_cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
-(void)backAction:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
