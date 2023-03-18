//
//  LXGAlbumCollectionViewCell.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGAlbumCollectionViewCell.h"
#import <Masonry/Masonry.h>
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface LXGAlbumCollectionViewCell ()
/// 相册首图
@property (nonatomic, strong) UIImageView * albumImageView;
/// 相册名
@property (nonatomic, strong) UILabel * albumNameLabel;
/// 相册数量
@property (nonatomic, strong) UILabel * albumNumberLabel;
@end
@implementation LXGAlbumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    //封面
    self.albumImageView             = [[UIImageView alloc]init];
    self.albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.albumImageView];
    [self.albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
    }];
    //相册名
    self.albumNameLabel      = [[UILabel alloc] init];
    self.albumNameLabel.font = [UIFont systemFontOfSize:16];
    self.albumNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.albumNameLabel];
    [self.albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumImageView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
    //数量
    self.albumNumberLabel      = [[UILabel alloc] init];
    self.albumNumberLabel.font = [UIFont systemFontOfSize:12];
    self.albumNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.albumNumberLabel];
    [self.albumNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumNameLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
}

#pragma mark - Set方法
-(void)setAlbumModel:(LXGAlbumModel *)albumModel {
    _albumModel                = albumModel;
    self.albumNameLabel.text   = albumModel.collectionTitle;
    self.albumNumberLabel.text = albumModel.collectionNumber;
}
/// 加载图片
-(void)loadImage:(NSIndexPath *)index {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    __weak typeof(self) weakSelf = self;
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.albumModel.firstAsset targetSize:CGSizeMake(kScreenWidth / 2, kScreenWidth / 2) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (weakSelf.row == index.row) {
            weakSelf.albumImageView.image = result;
        }
    }];
}
@end
