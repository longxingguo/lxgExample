//
//  LXGPhotoCollectionViewCell.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^LYFAlbumCollectionViewCellAction)(PHAsset *asset);
@interface LXGPhotoCollectionViewCell : UICollectionViewCell
/// 行数
@property (nonatomic, assign) NSInteger row;
/// 相片
@property (nonatomic, strong) PHAsset *asset;
/// 选中事件
@property (nonatomic, copy) LYFAlbumCollectionViewCellAction selectPhotoAction;
/// 是否被选中
@property (nonatomic, assign) BOOL isSelect;
#pragma mark - 加载图片
-(void)loadImage:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
