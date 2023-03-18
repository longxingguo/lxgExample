//
//  LXGColorTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGColorTool.h"
@implementation LXGColorTool
/// 颜色
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
+(UIColor *)colorWithString:(NSString *)string{
    return [self colorWithString:string andAlpha:1.0];
}
/// 颜色
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
/// @param alpha 透明度 0-1
+(UIColor *)colorWithString:(NSString *)string andAlpha:(CGFloat)alpha{
    NSString * colorString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([colorString hasPrefix:@"0X"]||[colorString hasPrefix:@"0x"]){
        colorString = [colorString substringFromIndex:2];
    }
    if ([colorString hasPrefix:@"#"]){
        colorString = [colorString substringFromIndex:1];
    }
    CGFloat alp   = 0.0;
    CGFloat red   = 0.0;
    CGFloat blue  = 0.0;
    CGFloat green = 0.0;
    switch ([colorString length]){
        case 3:{//#RGB
            alp   = alpha;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
        }break;
        case 4:{//#ARGB
            alp   = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
        }break;
        case 6:{//#RRGGBB
            alp   = alpha;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
        }break;
        case 8:{//#AARRGGBB
            alp   = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
        }break;
        default:{
            NSLog(@"同志注意了,你传入的色值有问题,被改为默认白色了,具体代码全局搜索这条log输出文字");
            return [UIColor whiteColor];
        }break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alp];
}
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length{
    NSString * substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString * fullHex   = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
/// 图片
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
+(UIImage *)colorImageWithString:(NSString *)string{
    CGRect       rect    = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self colorWithString:string].CGColor);
    CGContextFillRect(context, rect);
    UIImage    * image   = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/// 图片
/// @param string #RGB #ARGB #RRGGBB #AARRGGBB
/// @param size 大小
+(UIImage *)colorImageWithString:(NSString *)string andSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[self colorWithString:string].CGColor);
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, size.width, size.height));
    UIImage    * image   = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
