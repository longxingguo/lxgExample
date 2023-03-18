//
//  LXGColorTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//颜色
#define LColor(string)               [LXGColorTool colorWithString:string]
//颜色 透明度
#define LColorAlpha(string, alpha)   [LXGColorTool colorWithString:string andAlpha:alpha]
//颜色 获取图片
#define LColorImage(string)          [LXGColorTool colorImageWithString:string]
//颜色 大小 获取图片
#define LColorImageSize(string,size) [LXGColorTool colorImageWithString:string andSize:size]
NS_ASSUME_NONNULL_BEGIN
@interface LXGColorTool : NSObject
/// 颜色
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
+(UIColor *)colorWithString:(NSString *)string;
/// 颜色
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
/// @param alpha 透明度 0-1
+(UIColor *)colorWithString:(NSString *)string andAlpha:(CGFloat)alpha;
/// 图片
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
+(UIImage *)colorImageWithString:(NSString *)string;
/// 图片
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
/// @param size 大小
+(UIImage *)colorImageWithString:(NSString *)string andSize:(CGSize)size;
@end
NS_ASSUME_NONNULL_END
