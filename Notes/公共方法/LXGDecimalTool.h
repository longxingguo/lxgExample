//
//  LXGDecimalTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
//科学计数法获取double
#define LDecimalDouble(string,scale)              [LXGDecimalTool decimalNumberDouble:string andScale:scale]
//科学计数法获取integer
#define LDecimalInteger(string,scale)             [LXGDecimalTool decimalNumberNSInteger:string andScale:scale]
//科学计数法比较数字字符串大小
#define LDecimalCompar(string,comparString,scale) [LXGDecimalTool decimalResult:string andComparString:comparString andScale:scale]
NS_ASSUME_NONNULL_BEGIN
@interface LXGDecimalTool : NSObject
/// 科学计算法 返回浮点型
/// @param string 数字字符串
/// @param scale   精度几位
+ (double)decimalNumberDouble:(NSString *)string andScale:(short)scale;
/// 科学计算法 返回整型
/// @param string 数字字符串
/// @param scale  精度几位
+ (NSInteger)decimalNumberNSInteger:(NSString *)string andScale:(short)scale;
/// 返回比较的结果
/// @param string 字符串
/// @param comparString 比较的字符串
/// @param scale 精度几位
+ (NSComparisonResult)decimalResult:(NSString *)string andComparString:(NSString *)comparString andScale:(short)scale;
@end
NS_ASSUME_NONNULL_END
