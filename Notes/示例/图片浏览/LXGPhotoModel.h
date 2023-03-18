//
//  LXGPhotoModel.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^LXGPhotoModelAction)(void);
@interface LXGPhotoModel : NSObject
/// 相片
@property (nonatomic, strong) PHAsset *asset;
/// 高清图
@property (nonatomic, strong) UIImage *highDefinitionImage;
/// 获取图片成功事件
@property (nonatomic, copy  ) LXGPhotoModelAction getPictureAction;
//是否选中
@property (nonatomic, assign)BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
