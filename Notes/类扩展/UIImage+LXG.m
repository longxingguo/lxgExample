//
//  UIImage+LXG.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "UIImage+LXG.h"
#import<QuartzCore/QuartzCore.h>
#import<Accelerate/Accelerate.h>
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
@implementation UIImage (LXG)
- (UIImage *)removeColorWithMaxR:(float)maxR minR:(float)minR maxG:(float)maxG minG:(float)minG maxB:(float)maxB minB:(float)minB{
    const int  imageWidth      = self.size.width;
    const int  imageHeight     = self.size.height;
    size_t     bytesPerRow     = imageWidth * 4;
    uint32_t * rgbImageBuf     = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef    context    = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self.CGImage);
    int        pixelNum = imageWidth * imageHeight;
    uint32_t * pCurPtr  = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        uint8_t * ptr = (uint8_t*)pCurPtr;
        if (ptr[3] >= minR && ptr[3] <= maxR &&
            ptr[2] >= minG && ptr[2] <= maxG &&
            ptr[1] >= minB && ptr[1] <= maxB) {
            ptr[0] = 0;
        }
    }
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, NULL);
    CGImageRef        imageRef     = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast |kCGBitmapByteOrder32Host, dataProvider,NULL,YES,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
- (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length{
    NSString * substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString * fullHex   = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}











- (UIImage *)processUsingPixels:(UIImage*)inputImage {
    // 1. Get the raw pixels of the image
    //定义最高32位整形指针 *inputPixels
    UInt32 * inputPixels;
    //转换图片为CGImageRef,获取参数：长宽高，每个像素的字节数（4），每个R的比特数
    CGImageRef      inputCGImage     = [inputImage CGImage];
    NSUInteger      inputWidth       = CGImageGetWidth(inputCGImage);
    NSUInteger      inputHeight      = CGImageGetHeight(inputCGImage);
    CGColorSpaceRef colorSpace       = CGColorSpaceCreateDeviceRGB();
    NSUInteger      bytesPerPixel    = 4;
    NSUInteger      bitsPerComponent = 8;
    //每行字节数
    NSUInteger inputBytesPerRow      = bytesPerPixel * inputWidth;
    //开辟内存区域,指向首像素地址
    inputPixels                      = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    //根据指针，前面的参数，创建像素层
    CGContextRef context             = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //根据目前像素在界面绘制图像
    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    //接来下就是重点了！！！像素处理--------------------------------------------------------
    for (NSUInteger j = 0; j < inputHeight; j++) {
        for (NSUInteger i = 0; i < inputWidth; i++) {
            UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            UInt32 br,thisR,thisG,thisB,thisA;
            //这里直接移位获得RBGA的值,以及输出写的非常好！
            thisR=R(color);
            thisG=G(color);
            thisB=B(color);
            thisA=A(color);
            //NSLog(@"%d,%d,%d,%d",thisR,thisG,thisB,thisA);
            br=B(color)-R(color);
            *currentPixel = RGBAMake(br, br, br, A(color));
        }
    }
    //创建新图
    // 4. Create a new UIImage
    CGImageRef newCGImage     = CGBitmapContextCreateImage(context);
    UIImage  * processedImage = [UIImage imageWithCGImage:newCGImage];
    //释放
    // 5. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(inputPixels);
    return processedImage;
}

- (UIImage *)maskImage{
//    const CGFloat myMaskingColors[6] = {minR, maxR,  minG, maxG, minB, maxB};
    //不适用透明图片
    CGImageRef sourceImage        = self.CGImage;
    CGImageAlphaInfo info         = CGImageGetAlphaInfo(sourceImage);
    if (info != kCGImageAlphaNone) {
        NSData  * buffer    = UIImageJPEGRepresentation(self, 1);
        UIImage * newImage  = [UIImage imageWithData:buffer];
        sourceImage         = newImage.CGImage;
    }
    const CGFloat colorMasking[6] = {240, 255, 240, 255, 240, 255};
    CGImageRef masked             = CGImageCreateWithMaskingColors(sourceImage, colorMasking);
    UIImage  * retImage           = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
//图片旋转
-(UIImage *)rotateAngle:(CGFloat)angle{
    size_t width              = self.size.width  * self.scale;
    size_t height             = self.size.height * self.scale;
    //颜色通道为8因为0-255经过了8个颜色通道的变化
    //每一行图片的字节数因为我们采用的是ARGB/RGBA所以字节数为width * 4
    size_t bytesPerRow        = width *4;
    CGImageAlphaInfo info     = kCGImageAlphaPremultipliedFirst;
    CGContextRef     context  = CGBitmapContextCreate(nil, width, height,8, bytesPerRow,CGColorSpaceCreateDeviceRGB(),kCGBitmapByteOrderDefault|info);
    if(!context){
        return nil;
    }
    //将图片渲染到图形上下文中
    CGContextDrawImage(context,CGRectMake(0,0, width, height),self.CGImage);
    uint8_t * data       = (uint8_t*)CGBitmapContextGetData(context);
    //旋转前的数据
    vImage_Buffer src    = {data,height,width,bytesPerRow};
    //旋转后的数据
    vImage_Buffer dest   = {data,height,width,bytesPerRow};
    //背景颜色
    Pixel_8888 backColor = {0,0,0,0};
    //填充颜色
    vImage_Flags flags   = kvImageBackgroundColorFill;
    //旋转context
    vImageRotate_ARGB8888(&src, &dest,nil, angle * M_PI/180.f, backColor, flags);
    CGImageRef imageRef    = CGBitmapContextCreateImage(context);
    UIImage  * rotateImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    return rotateImage;
}
//边框
-(UIImage *)circleName:(NSString *)name andSize:(CGSize)size andborderWidth:(CGFloat)borderWidth andborderColor:(UIColor *)borderColor{
    UIImage * oldImage    = [UIImage imageNamed:name];
    CGFloat   imageW      = size.width  + 2 * borderWidth;
    CGFloat   imageH      = size.height + 2 * borderWidth;
    CGSize    imageSize   = CGSizeMake(imageW, imageH);
    // 取得当前的上下文
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctxRef   = UIGraphicsGetCurrentContext();
    // 画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX   = bigRadius; // 圆心
    CGFloat centerY   = bigRadius;
    CGContextAddArc(ctxRef, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctxRef); // 画圆
    //小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctxRef, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    //裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctxRef);
    //画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, size.width, size.height)];
    //取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}
//图片拉伸
-(UIImage *)tensile:(UIEdgeInsets)edgeInsets{
    return  [self resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
}
/// 缩
/// @param targetWidth 需要缩的宽
- (UIImage*)compresstoTargetWidth:(CGFloat)targetWidth {
    //获取原图片的大小尺寸
    CGSize imageSize     = self.size;
    CGFloat width        = imageSize.width;
    CGFloat height       = imageSize.height;
    //根据目标图片的宽度计算目标图片的高度
    CGFloat targetHeight = (targetWidth / width) * height;
    //开启图片上下文
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    //绘制图片
    [self drawInRect:CGRectMake(0,0, targetWidth, targetHeight)];
    //从上下文中获取绘制好的图片
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    return newImage;
}

/// 先压  在 缩
/// @param maxLength 字节  列入2m  = 2*1024*1024字节 
- (UIImage *)compresstoByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data        = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return self;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i  = 0; i < 6; ++i) {
        compression = (max + min) / 2;
            data    = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min     = compression;
        } else if (data.length > maxLength) {
            max     = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio  = (CGFloat)maxLength / data.length;
        CGSize  size   = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}










@end
