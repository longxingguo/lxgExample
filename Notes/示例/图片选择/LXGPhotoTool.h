//
//  LXGPhotoTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/2.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGPhotoTool : NSObject
/**
 拍照获取图片 
 @param allowCrop   是否可以剪裁
 @param complete    图片
 */
+(void)getPhotoAllowCrop:(BOOL)allowCrop andComplete:(void(^)(UIImage *image))complete;
/**
 相册获取图片
 @param photoNumber 几张
 @param allowCrop   是否可以剪裁
 @param complete    图片数组
 */
+(void)getPhotoWithPhotoNumber:(NSInteger)photoNumber AllowCrop:(BOOL)allowCrop andComplete:(void(^)(NSArray *imageArray))complete;
@end
NS_ASSUME_NONNULL_END
