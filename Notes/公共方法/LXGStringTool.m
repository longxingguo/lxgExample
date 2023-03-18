//
//  LXGStringTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGStringTool.h"
@implementation LXGStringTool
#pragma mark ------------------------------------------------------------- NSString
/**
 电话号码正则
 */
+ (BOOL)isMobileNumber:(NSString *)string{
    if (string.length != 11){
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString    * MOBILE          = @"^1([0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSString    * CM              = @"^1(3[4-9]|4[78]|5[0-27-9]|7[028]|8[2-478]|9[8])\\d{8}$";
    NSString    * CU              = @"^1(3[0-2]|4[56]|5[56]|6[6]|7[0156]|8[56])\\d{8}$";
    NSString    * CT              = @"^1(3[3]|4[9]|53|7[0347]|8[019]|9[9])\\d{8}$";
    NSPredicate * regexmobile     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate * regexcm         = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate * regexcu         = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate * regexct         = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regexmobile evaluateWithObject:string] == YES)|| ([regexcm evaluateWithObject:string]  == YES)|| ([regexcu evaluateWithObject:string]  == YES)|| ([regexct evaluateWithObject:string]  == YES)){
        return YES;
    }else{
        return NO;
    }
}
/**
 是否包含某个字符串
 */
+ (BOOL)isRangeOfString:(NSString *)string1 andString:(NSString *)string2{
    return [string1 rangeOfString:string2].location != NSNotFound ? YES : NO;
}
+ (BOOL)isContainsString:(NSString *)string1 andString:(NSString *)string2{
    return [string1 containsString:string2];
}
/**
 获取拼音首字母(传入汉字字符串, 返回第一个字符大写拼音首字母)
 */
+ (NSString *)firstCharactor:(NSString *)string{
    //转成了可变字符串
    NSMutableString * str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString * pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}
/**
 是否全为数字
 */
+ (BOOL)isNum:(NSString *)String{
    String = [String stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(String.length > 0) {
        return NO;
    }
    return YES;
}
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner * scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+ (BOOL)deptNumInputShouldNumber:(NSString *)string{
    if(string.length == 0){
        return NO;
    }
    NSString    * regex = @"[0-9]*";
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}
/**
查找子字符串在父字符串中的所有位置
 */
+ (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    int     location = 0;
    NSRange range    = [content rangeOfString:tab];
    NSMutableArray * locationArr = [[NSMutableArray alloc]init];
    if (range.location == NSNotFound){
        return locationArr;
    }
    NSString * subStr = content;
    while (range.location != NSNotFound){
        if (location == 0) {
            location += range.location;
        } else {
            location += range.location + tab.length;
        }
        NSNumber * number = [NSNumber numberWithUnsignedInteger:location];
        [locationArr addObject:number];
        subStr = [subStr substringFromIndex:range.location + range.length];
        range  = [subStr rangeOfString:tab];
    }
    return locationArr;
}
#pragma mark ------------------------------------------------------------ NSAttributedString
/**
 给字符串添加下划线或者中划线
 */
+ (NSAttributedString *)underlineAndStrikethrough:(NSString *)string andIsunderline:(BOOL)isunderline{
    if(isunderline){
        return [[NSAttributedString alloc] initWithString:string attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
    }
    return [[NSAttributedString alloc] initWithString:string attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}];
}
/**
给字符串某一部分添加颜色
 */
+ (NSMutableAttributedString *)attributedStringColor:(NSString *)string Array:(NSArray<NSString *>*)stringArray AndColorArray:(NSArray<UIColor *>*)colorArray AndFontArray:(NSArray<NSNumber *>*)fontArray{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    for(int i = 0;i<stringArray.count;i++){
        NSRange range = [[attrStr string] rangeOfString:stringArray[i]];
        if(fontArray.count){
            [attrStr addAttributes:@{NSForegroundColorAttributeName:colorArray[i],NSFontAttributeName:[UIFont systemFontOfSize:fontArray[i].doubleValue]} range:range];
        }else{
            [attrStr addAttributes:@{NSForegroundColorAttributeName:colorArray[i]} range:range];
        }
    }
    return attrStr;
}
@end
