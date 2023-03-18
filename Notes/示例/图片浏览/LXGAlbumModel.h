//
//  LXGAlbumModel.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface LXGAlbumModel : NSObject
/// 相册
@property (nonatomic, strong) PHAssetCollection *collection;
/// 第一个相片
@property (nonatomic, strong) PHAsset *firstAsset;
/// 第一个相片
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;
/// 相册名
@property (nonatomic, copy) NSString *collectionTitle;
/// 总数
@property (nonatomic, copy) NSString *collectionNumber;
/// 选中的图片
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectRows;
@end

NS_ASSUME_NONNULL_END
