//
//  LXGAlbumManager.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/19.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LXGPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LXGAlbumManager : NSObject
/**
 显示相册
 
 @param viewController 跳转的控制器
 @param maxCount 最大选择图片数量
 @param albumArray 返回的图片数组
 */
+(void)showPhotosManager:(UIViewController *)viewController withMaxImageCount:(NSInteger)maxCount withAlbumArray:(void(^)(NSMutableArray<LXGPhotoModel *> *albumArray))albumArray;
@end

NS_ASSUME_NONNULL_END
