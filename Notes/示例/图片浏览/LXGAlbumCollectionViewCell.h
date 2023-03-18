//
//  LXGAlbumCollectionViewCell.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXGAlbumModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LXGAlbumCollectionViewCell : UICollectionViewCell
/// 相册
@property (nonatomic, strong) LXGAlbumModel *albumModel;
/// 行数
@property (nonatomic, assign) NSInteger row;
/// 加载图片
-(void)loadImage:(NSIndexPath *)index;
@end

NS_ASSUME_NONNULL_END
