//
//  LXGFontTool.m
//  Notes
//
//  Created by 龙兴国 on 2019/11/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGFontTool.h"

@implementation LXGFontTool
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleL:(double)font{
    return [self fontScale:font andFontString:@"PingFangSC-Light"];
}
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleR:(double)font{
    return [self fontScale:font andFontString:@"PingFangSC-Regular"];
}
/// 返回UIFont
/// @param font 字体大小
+(UIFont *)fontScaleS:(double)font{
    return [self fontScale:font andFontString:@"PingFangSC-Semibold"];
}
/// 返回UIFont
/// @param font 字体大小
/// @param fontString 字体类型
+(UIFont *)fontScale:(double)font andFontString:(NSString *)fontString{
    //PingFangSC-Light    纤细
    //PingFangSC-Regular  常规
    //PingFangSC-Semibold 黑体
    return [UIFont fontWithName:fontString size:font * LScale];
}
@end
