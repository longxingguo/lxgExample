//
//  LXGAlbumViewController.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGAlbumViewController.h"
#import <Photos/Photos.h>
#import "LXGAlbumModel.h"
#import "LXGAlbumCollectionViewCell.h"
#import "LXGPhotoViewController.h"
@interface LXGAlbumViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
/// 相册列表
@property (nonatomic, strong) UICollectionView *albumCollectionView;
/// 相册数组
@property (nonatomic, strong) NSMutableArray<LXGAlbumModel *> *assetCollectionList;
@end

@implementation LXGAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //视图
    [self creatUI];
    //获取相册和相册第一张图
    [self getAlbumAndThumb];
}
#pragma mark - 设置控制器
-(void)creatUI {
    self.view.backgroundColor              = [UIColor whiteColor];
    self.navigationItem.title              = @"图库";
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];;
    [self.view addSubview:self.albumCollectionView];
}
//相册
- (void)getAlbumAndThumb{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //获得全部相片
        PHFetchResult<PHAssetCollection *> *cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        //个人收藏相册
        PHFetchResult<PHAssetCollection *> *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
        //系统相册外的相册
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        //所有
        for (PHAssetCollection *collection in cameraRolls) {
            LXGAlbumModel *model = [[LXGAlbumModel alloc] init];
            model.collection     = collection;
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        //喜欢
        for (PHAssetCollection *collection in favoritesCollection) {
            LXGAlbumModel *model = [[LXGAlbumModel alloc] init];
            model.collection     = collection;
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        //其他
        for (PHAssetCollection *collection in assetCollections) {
            LXGAlbumModel *model = [[LXGAlbumModel alloc] init];
            model.collection     = collection;
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.albumCollectionView reloadData];
        });
    });
}
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetCollectionList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXGAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LXGAlbumCollectionViewCell class]) forIndexPath:indexPath];
    cell.row        = indexPath.row;
    cell.albumModel = self.assetCollectionList[indexPath.row];
    [cell loadImage:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LXGAlbumModel * model       = self.assetCollectionList[indexPath.row];
    LXGPhotoViewController * VC = [[LXGPhotoViewController alloc]init];
    VC.model                    = model;
    [self.navigationController pushViewController:VC animated:YES];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 15.f) / 2.f, (self.view.frame.size.width - 15.f) / 2.f);
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
#pragma mark -- 点击事件
-(void)backAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 懒加载
//相册列表
-(UICollectionView *)albumCollectionView {
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection               = UICollectionViewScrollDirectionVertical;
        
        _albumCollectionView                 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _albumCollectionView.delegate        = self;
        _albumCollectionView.dataSource      = self;
        _albumCollectionView.backgroundColor = [UIColor whiteColor];
        _albumCollectionView.scrollEnabled   = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        [_albumCollectionView registerClass:[LXGAlbumCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([LXGAlbumCollectionViewCell class])];
    }
    return _albumCollectionView;
}
//取消
-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 50, 50);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
//相册数组
-(NSMutableArray<LXGAlbumModel *> *)assetCollectionList{
    if (!_assetCollectionList) {
        _assetCollectionList = [NSMutableArray array];
    }
    return _assetCollectionList;
}
@end
