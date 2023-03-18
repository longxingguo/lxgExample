//
//  LXGDecimalTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGDecimalTool.h"

@implementation LXGDecimalTool
/// 科学计算法 返回浮点型
/// @param string 数字字符串
/// @param scale   精度几位
+ (double)decimalNumberDouble:(NSString *)string andScale:(short)scale{
    NSDecimalNumberHandler * plain   = [NSDecimalNumberHandler defaultDecimalNumberHandler];
    NSDecimalNumber        * number  = [NSDecimalNumber  decimalNumberWithString:string];
    NSDecimalNumber        * pnumber = [number decimalNumberByRoundingAccordingToBehavior:plain];
    return  [pnumber doubleValue];
}
/// 科学计算法 返回整型
/// @param string 数字字符串
/// @param scale  精度几位
+ (NSInteger)decimalNumberNSInteger:(NSString *)string andScale:(short)scale{
    NSDecimalNumberHandler * plain   = [NSDecimalNumberHandler defaultDecimalNumberHandler];
    NSDecimalNumber        * number  = [NSDecimalNumber  decimalNumberWithString:string];
    NSDecimalNumber        * pnumber = [number decimalNumberByRoundingAccordingToBehavior:plain];
    return  [pnumber integerValue];
}
/// 返回比较的结果
/// @param string 字符串
/// @param comparString 比较的字符串
/// @param scale 精度几位
+ (NSComparisonResult)decimalResult:(NSString *)string andComparString:(NSString *)comparString andScale:(short)scale{
    NSDecimalNumberHandler * plain    = [NSDecimalNumberHandler defaultDecimalNumberHandler];
    NSDecimalNumber        * number1  = [NSDecimalNumber  decimalNumberWithString:string];
    NSDecimalNumber        * pnumber1 = [number1 decimalNumberByRoundingAccordingToBehavior:plain];
    NSDecimalNumber        * number2  = [NSDecimalNumber  decimalNumberWithString:comparString];
    NSDecimalNumber        * pnumber2 = [number2 decimalNumberByRoundingAccordingToBehavior:plain];
    return [pnumber1 compare:pnumber2];
}
@end
