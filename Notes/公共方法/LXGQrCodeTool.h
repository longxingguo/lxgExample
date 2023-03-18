//
//  LXGQrCodeTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define LQrCode(string,size)   [LXGQrCodeTool qRcode:string andSize:size]
#define LBarCode(string,size)  [LXGQrCodeTool barCode:string andSize:size]
NS_ASSUME_NONNULL_BEGIN
@interface LXGQrCodeTool : NSObject
/// 普通二维码
/// @param string 二维码字符
/// @param size 二维码大小
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size;
/// 彩色的二维码
/// @param string 二维码字符
/// @param size 二维码大小
/// @param qrColor 二维码的颜色
/// @param backgroundColor 二维码的背景颜色
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size andQRColor:(UIColor *)qrColor andBackgroundColor:(UIColor *)backgroundColor;
/// 带有logo的二维码
/// @param string 二维码字符
/// @param size 二维码大小
/// @param logoScale 二维码图标相对二维码的大小比例 0到1之间 一般不超过0.5
/// @param logoImageName 二维码logo图标字符串
/// @param radious logo圆角
/// @param borderWidth 二维码图标边框宽度
/// @param borderColor 二维码图标边框的颜色
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size andLogoScale:(CGFloat)logoScale andLogoImageName:(NSString *)logoImageName andradious:(CGFloat)radious andborderWidth:(CGFloat)borderWidth andborderColor:(UIColor *)borderColor;
/// 生成条形码
/// @param string 二维码字符
/// @param size 条形码大小
+ (UIImage*)barCode:(NSString *)string andSize:(CGSize)size;
@end
NS_ASSUME_NONNULL_END
