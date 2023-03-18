//
//  LXGQrCodeTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGQrCodeTool.h"
@implementation LXGQrCodeTool
/// 普通二维码
/// @param string 二维码字符
/// @param size 二维码大小
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size{
    return [self createUIImageFormCIImage:[[self getQRCIFilter:string] outputImage] withSize:size];
}
//得到二维码CIFilter
+ (CIFilter *)getQRCIFilter:(NSString *)string{
    //必转 不转崩溃
    NSData   * infoData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //创建CIFilte(滤镜)对象
    CIFilter * filter   = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜默认设置
    [filter setDefaults];
    //重设二维码输入信息
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    //重设二维码错误的等级,就是容错率
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    return filter;
}
//处理二维码模糊 变为高清
+ (UIImage *)createUIImageFormCIImage:(CIImage *)image withSize:(CGSize)size{
    CGImageRef   cgImage    = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextDrawImage(contextRef, CGContextGetClipBoundingBox(contextRef), cgImage);
    UIImage * codeImage     = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}
/// 彩色的二维码
/// @param string 二维码字符
/// @param size 二维码大小
/// @param qrColor 二维码的颜色
/// @param backgroundColor 二维码的背景颜色
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size andQRColor:(UIColor *)qrColor andBackgroundColor:(UIColor *)backgroundColor{
    //创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    [color_filter setDefaults];
    //需要设定颜色的图片
    [color_filter setValue:[[self getQRCIFilter:string] outputImage] forKey:@"inputImage"];
    //前景色  二维码的颜色
    [color_filter setValue:[CIColor colorWithCGColor:qrColor.CGColor] forKey:@"inputColor0"];
    //背景色  二维码背景的颜色
    [color_filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"];
    return [self createUIImageFormCIImage:color_filter.outputImage withSize:size];
}
/// 带有logo的二维码
/// @param string 二维码字符
/// @param size 二维码大小
/// @param logoScale 二维码图标相对二维码的大小比例 0到1之间 一般不超过0.5
/// @param logoImageName 二维码logo图标字符串
/// @param radious logo圆角
/// @param borderWidth 二维码图标边框宽度
/// @param borderColor 二维码图标边框的颜色
+ (UIImage *)qRcode:(NSString *)string andSize:(CGSize)size andLogoScale:(CGFloat)logoScale andLogoImageName:(NSString *)logoImageName andradious:(CGFloat)radious andborderWidth:(CGFloat)borderWidth andborderColor:(UIColor *)borderColor{
    UIImage * qrimage         = [self qRcode:string andSize:size];
    //拿到logo image坐标
    CGRect    logorect        = [self getLogoImageRectWithImage:qrimage andLogoScale:logoScale];
    //把logo image按照得到的宽高处理
    UIImage * logoimage       = [self getLogoImageWithImage:[UIImage imageNamed:logoImageName] scaleToSize:logorect.size];
    if (borderWidth > 0) {
        //给logo image加边框
        logoimage = [self getBorderImageWithImage:logoimage andSize:logoimage.size andradious:radious andborderWith:borderWidth andborderColor:borderColor];
    }
    return [self getFinalImageWithImage:qrimage andBorderLogoImage:logoimage andLogoRext:logorect];
}
//合成 qrimage 和 borderlogoimage
+ (UIImage *)getFinalImageWithImage:(UIImage *)qrimage andBorderLogoImage:(UIImage *)borderlogoimage andLogoRext:(CGRect)logorect{
    UIGraphicsBeginImageContextWithOptions(qrimage.size, NO, 0.0);
    [qrimage drawInRect:CGRectMake(0, 0, qrimage.size.width, qrimage.size.height)];
    [borderlogoimage drawInRect:logorect];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//给logo image加边框
+ (UIImage *)getBorderImageWithImage:(UIImage *)image  andSize:(CGSize)size andradious:(CGFloat)radious andborderWith:(CGFloat)borderWidth andborderColor:(UIColor *)borderColor{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    //区域1
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radious];
    [borderColor setFill];
    [path fill];
    //区域2
    UIBezierPath * clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth , borderWidth , size.width -  2 * borderWidth, size.height - 2 * borderWidth) cornerRadius:radious];
    [clipPath addClip];
    [image drawAtPoint:CGPointZero];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//把logo image按照得到的宽高处理
+ (UIImage *)getLogoImageWithImage:(UIImage *)image scaleToSize:(CGSize)size{
    //把logo按照宽高处理
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width , size.height)];
    UIImage * scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
//拿到logo image坐标
+ (CGRect)getLogoImageRectWithImage:(UIImage *)startimage andLogoScale:(CGFloat)logoScale{
    //logo宽高  根据传入的比例生成
    CGFloat logo_imageW  = startimage.size.width   * logoScale;
    CGFloat logo_imageH  = startimage.size.height  * logoScale;
    CGFloat logo_imageX  = (startimage.size.width  - logo_imageW) /2.0;
    CGFloat logo_imageY  = (startimage.size.height - logo_imageH) /2.0;
    return CGRectMake(logo_imageX, logo_imageY, logo_imageW, logo_imageH);
}
/// 生成条形码
/// @param string 二维码字符
/// @param size 条形码大小
+ (UIImage*)barCode:(NSString *)string andSize:(CGSize)size{
    NSData   * data   = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter * filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setDefaults];
    [filter setValue:data forKey:@"inputMessage"];
    //条形码设置条形码上下左右间距
    //[filter setValue:@(5) forKey:@"inputQuietSpace"];
    // 消除模糊
    CGFloat scaleX    = size.width  / [filter outputImage].extent.size.width;
    CGFloat scaleY    = size.height / [filter outputImage].extent.size.height;
    return [UIImage imageWithCIImage:[[filter outputImage] imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)]];
}
@end
