//
//  LXGGifTool.m
//  Notes
//
//  Created by 龙兴国 on 2020/4/17.
//  Copyright © 2020 龙兴国. All rights reserved.
//
#import "LXGGifTool.h"
#import <MobileCoreServices/MobileCoreServices.h>
@implementation LXGGifTool
/// 合成gif
/// @param imageArray 图片数组 支持UIImage  NSString
+(void)composeGIF:(NSArray *)imageArray{
    NSString * imagepPath              = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //创建gif路径
    NSString * gifPath                 = [imagepPath stringByAppendingString:@"/my.gif"];
    //图像目标
    //allocator   : 分配器,通常使用kCFAllocatorDefault
    //filePath    : 路径
    //pathStyle   : 路径风格,我们就填写kCFURLPOSIXPathStyle 更多请打问号自己进去帮助看
    //isDirectory : 一个布尔值,用于指定是否filePath被当作一个目录路径解决时相对路径组件
    CFURLRef url                       = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
    //通过一个url返回图像目标 (CFURLRef)[NSURL fileURLWithPath:cashPath]
    CGImageDestinationRef destination  = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imageArray.count, NULL);
    //设置gif信息
    NSMutableDictionary * pdic         = [NSMutableDictionary dictionary];
    //颜色
    [pdic setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    //颜色类型
    [pdic setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    //颜色深度 8 或 16
    [pdic setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    //是否重复 0无限重复
    [pdic setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    //(NSString*)kCGImagePropertyPixelWidth]  (NSString*)kCGImagePropertyPixelHeight]
    //配置
    NSDictionary * property      = [NSDictionary dictionaryWithObject:pdic forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif 设置gif的信息,播放间隔时间,基本数据,和delay时间,
    NSDictionary * ddic          = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1], (NSString *)kCGImagePropertyGIFDelayTime, nil];
    NSDictionary * delayProperty = [NSDictionary dictionaryWithObject:ddic forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (id imagepath in imageArray){
        UIImage * image = nil;
        if ([imagepath isKindOfClass:UIImage.class]) {
            image       = (UIImage *)imagepath;
        }
        if ([imagepath isKindOfClass:NSString.class]) {
            image       = [UIImage imageNamed:imagepath];
        }
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)delayProperty);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)property);
    CGImageDestinationFinalize(destination);
    CFRelease(url);
    CFRelease(destination);
    NSFileManager* manager  = [NSFileManager defaultManager];
    long  long size         = [[manager attributesOfItemAtPath:gifPath error:nil] fileSize];
    NSLog(@"%f",size/1024.0/1024.0);
}
//UIImage * image = [UIImage imageWithContentsOfFile:imagepath];//路径获取
/// 合成图片
/// @param image1 图片1
/// @param image2 图片2
+(UIImage *)composeImage:(UIImage *)image1 andUIImage:(UIImage*)image2{
    CGSize size  = CGSizeZero;
    size.width   = image1.size.width>image2.size.width?image1.size.width:image2.size.width;
    size.height  = image1.size.height>image2.size.height?image1.size.height:image2.size.height;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGRect Rect1 = CGRectMake(0, 0, image1.size.width,image1.size.height);
    [image1 drawInRect:Rect1];
    CGRect Rect2 = CGRectMake(0, 0, image2.size.width,image2.size.height);
    [image2 drawInRect:Rect2];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
/**    UIImage图片转成Base64字符串：
       UIImage *originImage = image;
       NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
       NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
       NSLog(@"encodedImageStr==%@",encodedImageStr);
        

        
        
//     Base64字符串转UIImage图片：
       NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
       UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
       UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, 200, 400)];
       [imgView setImage:decodedImage];
       [self.view addSubview:imgView];
       NSLog(@"decodedImage==%@",decodedImageData);*/
