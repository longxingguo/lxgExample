//
//  LXGFontTool.h
//  Notes
//
//  Created by 龙兴国 on 2019/11/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
///字体大小 字体类型默认PingFangSC-Light
#define LFontL(font)                  [LXGFontTool fontScaleL:font]
///字体大小 字体类型默认PingFangSC-Regular
#define LFontR(font)                  [LXGFontTool fontScaleR:font]
///字体大小 字体类型默认PingFangSC-Semibold
#define LFontS(font)                  [LXGFontTool fontScaleS:font]
///字体大小 字体类型
#define LFontSting(font,string)       [LXGFontTool fontScale:font andFontString:string]
NS_ASSUME_NONNULL_BEGIN
@interface LXGFontTool : NSObject
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleL:(double)font;
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleR:(double)font;
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleS:(double)font;
/// 返回UIFont
/// @param font 字体大小
/// @param fontString 字体类型
+(UIFont *)fontScale:(double)font andFontString:(NSString *)fontString;
@end
NS_ASSUME_NONNULL_END
