//
//  LXGStringTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGStringTool : NSObject
#pragma mark ------------------------------------------------------------- NSString
/**
 电话号码正则
 @return YES or NO
 */
+ (BOOL)isMobileNumber:(NSString *)string;
/**
 是否包含某个字符串
 @param  string1 字符串
 @param  string2 要查找的字符串
 @return YES 存在 NO 不存在
 */
+ (BOOL)isRangeOfString:(NSString *)string1 andString:(NSString *)string2;
+ (BOOL)isContainsString:(NSString *)string1 andString:(NSString *)string2;
/**
 获取拼音首字母(传入汉字字符串, 返回第一个字符大写拼音首字母)
 @return NSString
 */
+ (NSString *)firstCharactor:(NSString *)string;
/**
 是否全为数字
 @return YES 是 NO 不是
 */
+ (BOOL)isNum:(NSString *)String;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)deptNumInputShouldNumber:(NSString *)string;
#pragma mark ------------------------------------------------------------ NSAttributedString
/**
 给字符串添加下划线或者中划线
 @param  isunderline YES下划线 NO中划线
 @return NSAttributedString
 */
+ (NSAttributedString *)underlineAndStrikethrough:(NSString *)string andIsunderline:(BOOL)isunderline;

/**
 给字符串某一部分添加颜色
 @param string 字符串
 @param stringArray 要改变颜色的字符串数组         如 @[@"123",@"456"];
 @param colorArray  颜色数组 和字符串数组一一对应   如 @[[UIColor redColor],[UIColor greenColor]];
 @param fontArray   字体数组 和字符串数组一一对应   如 @[@(11),@(15)]
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)attributedStringColor:(NSString *)string Array:(NSArray<NSString *>*)stringArray AndColorArray:(NSArray<UIColor *>*)colorArray AndFontArray:(NSArray<NSNumber *>*)fontArray;
@end
NS_ASSUME_NONNULL_END
