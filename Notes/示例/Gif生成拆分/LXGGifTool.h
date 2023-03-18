//
//  LXGGifTool.h
//  Notes
//
//  Created by 龙兴国 on 2020/4/17.
//  Copyright © 2020 龙兴国. All rights reserved.
//
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGGifTool : NSObject
/// 合成gif
/// @param imageArray 图片数组 支持UIImage  NSString
+(void)composeGIF:(NSArray *)imageArray;
/// 合成图片
/// @param image1 图片1
/// @param image2 图片2
+(UIImage *)composeImage:(UIImage *)image1 andUIImage:(UIImage*)image2;
@end
NS_ASSUME_NONNULL_END
