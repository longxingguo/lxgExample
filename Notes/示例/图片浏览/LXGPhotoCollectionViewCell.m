//
//  LXGPhotoCollectionViewCell.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGPhotoCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "LXGPhotoManger.h"
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface LXGPhotoCollectionViewCell ()
/// 相片
@property (nonatomic, strong) UIImageView *photoImageView;
/// 半透明遮罩
@property (nonatomic, strong) UIView   * translucentView;
/// 选中按钮
@property (nonatomic, strong) UIButton * selectButton;
@end

@implementation LXGPhotoCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    //图片
    self.photoImageView                     = [[UIImageView alloc] init];
    self.photoImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.photoImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //遮罩
    self.translucentView                 = [[UIView alloc] init];
    self.translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self.contentView addSubview:self.translucentView];
    [self.translucentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.translucentView.hidden = YES;
    //选择
    self.selectButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.layer.borderColor   = [UIColor whiteColor].CGColor;
    self.selectButton.layer.borderWidth   = 1.f;
    self.selectButton.layer.cornerRadius  = 12.5f;
    self.selectButton.layer.masksToBounds = YES;
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.width.height.equalTo(@(25));
    }];
}
-(void)selectPhoto:(UIButton *)button {
    if (self.selectPhotoAction) {
        self.selectPhotoAction(self.asset);
    }
}
#pragma mark - Set方法
-(void)setIsSelect:(BOOL)isSelect {
    _isSelect                   = isSelect;
    self.translucentView.hidden = !isSelect;
    [self.selectButton setBackgroundImage:isSelect ? [UIImage imageNamed: @"selectImage_select"] : nil forState:UIControlStateNormal];
    if ([LXGPhotoManger standardPhotoManger].maxCount == [LXGPhotoManger standardPhotoManger].choiceCount) {
        self.translucentView.hidden = NO;
        if (isSelect) {
            _translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        } else {
            _translucentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        }
    } else {
        _translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
}
#pragma mark - 加载图片
-(void)loadImage:(NSIndexPath *)indexPath {
    CGFloat imageWidth             = (kScreenWidth - 20.f) / 3.f;
    self.photoImageView.image      = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth * [UIScreen mainScreen].scale, imageWidth * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (self.row == indexPath.row) {
            self.photoImageView.image = result;
        }
    }];
}
@end
