//
//  LXGGifViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/10/16.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGGifViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LXGGifTool.h"
@interface LXGGifViewController ()
@property (nonatomic ,strong)UIImageView * imageView;
@end
@implementation LXGGifViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    //获得本地文件路径 拿不到Assets.xcassets的路径
    NSString * str    = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpg"];
    //将本地文件的路径转成url；
    NSURL    * urlStr = [NSURL fileURLWithPath:str];
    //获得本地文件的路径并转url
    NSURL    * url    = [[NSBundle mainBundle]URLForResource:@"icon_hud_1.png"withExtension:nil];
    NSLog(@"%@--%@",urlStr.absoluteString,url.absoluteString);
    self.imageView                 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 214, 133)];
    self.imageView.contentMode     = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    UIButton * button1      = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 50, 50)];
    UIButton * button2      = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 50, 50)];
    button1.backgroundColor = [UIColor greenColor];
    button2.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [self.view addSubview:button2];
}
- (void)button1Click{
    NSArray * array = @[@"icon_hud_1",
                        @"icon_hud_2",
                        @"icon_hud_3",
                        @"icon_hud_4",
                        @"icon_hud_5",
                        @"icon_hud_6",
                        @"icon_hud_7",
                        @"icon_hud_8",
                        @"icon_hud_9"];
    
    
    NSMutableArray * imagearray = [NSMutableArray array];
//    for (int i = 0; i < 60; i++) {
//        UIImage * image = [self getShotImage];
//        [imagearray addObject:image];
//    }
//    [self composeGIF:array];
//    [LXGGifTool composeGIF:array];
    [self shotImage:imagearray];
}
-(void)saveImage:(UIImage *)image filename:(NSString *)filename {
    CFURLRef url                       = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filename, kCFURLPOSIXPathStyle, false);
    CGImageDestinationRef destination  = CGImageDestinationCreateWithURL(url, kUTTypeGIF, 1, NULL);
    CGImageDestinationAddImage(destination, image.CGImage, nil);
    CGImageDestinationFinalize(destination);
    CFRelease(url);
    CFRelease(destination);
}
-(void)shotImage:(NSMutableArray *)array{
    if (array.count == 30) {
        NSString * imagepPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        for (int i= 0;i<array.count;i++) {
            UIImage  * image       = array[i];
            NSString * pngPath     = [imagepPath stringByAppendingString:[NSString stringWithFormat:@"/%lu.png",(unsigned long)array.count]];
            NSData   * PNGData     = UIImagePNGRepresentation(image);
            [PNGData writeToFile:pngPath atomically:YES];
           // [self saveImage:image filename:pngPath];
        }
    }else{
        UIImage  * image = [self getShotImage];
        [array addObject:image];
        [self shotImage:array];
    }
}
-(UIImage *)getShotImage{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
//合成
- (void)composeGIF:(NSArray *)imagePathArray{
    NSString * imagepPath              = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * gifPath                 = [imagepPath stringByAppendingString:@"/my.gif"];
    CFURLRef url                       = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)gifPath, kCFURLPOSIXPathStyle, false);
    CGImageDestinationRef destination  = CGImageDestinationCreateWithURL(url, kUTTypeGIF, imagePathArray.count, NULL);
    NSMutableDictionary * pdic         = [NSMutableDictionary dictionary];
    [pdic setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [pdic setObject:(NSString *)kCGImagePropertyColorModelRGB forKey:(NSString *)kCGImagePropertyColorModel];
    [pdic setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [pdic setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    NSDictionary * property            = [NSDictionary dictionaryWithObject:pdic forKey:(NSString *)kCGImagePropertyGIFDictionary];
    NSDictionary * ddic                = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1], (NSString *)kCGImagePropertyGIFDelayTime, nil];
    NSDictionary * delayProperty       = [NSDictionary dictionaryWithObject:ddic forKey:(NSString *)kCGImagePropertyGIFDictionary];
    for (id imagepath in imagePathArray){
        UIImage * image = nil;
        if ([imagepath isKindOfClass:UIImage.class]) {
            image = imagepath;
        }
        if ([imagepath isKindOfClass:NSString.class]) {
            image = [UIImage imageNamed:imagepath];
        }
        CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)delayProperty);
    }
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)property);
    CGImageDestinationFinalize(destination);
    CFRelease(url);
    CFRelease(destination);
}













- (void)button2Click{
    NSString * imagepPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * gifPath    = [imagepPath stringByAppendingString:@"/my.gif"];
    NSData   * data       = [[NSData alloc]initWithContentsOfURL:[NSURL fileURLWithPath:gifPath]];
    self.imageView.image  = [self animatedGIFWithData:data];
}
//分解
- (NSMutableArray *)decomposeGIF:(NSString *)gifPath{
    //图片保存路径
    NSString       * imagepPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //用于保存所有图片的路径
    NSMutableArray * imgPaths   = [NSMutableArray array];
    //1.gif转换成data
    NSData         * gifData    = [NSData dataWithContentsOfFile:gifPath];
    //2.通过data获取image的数据源
    CGImageSourceRef source     = CGImageSourceCreateWithData((CFDataRef)gifData, NULL);
    //CGImageSourceRef source     = CGImageSourceCreateWithURL(url, NULL);
    //3.获取gif帧数
    size_t           count      = CGImageSourceGetCount(source);
    //NSDictionary *gifProperties = (__bridge NSDictionary *) CGImageSourceCopyProperties(gifSource, NULL);
    //NSDictionary *gifDictionary =[gifProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary];
    //
    for (int i = 0; i < count; i++) {
        //4.获取单帧图片
        CGImageRef   imageRef     = CGImageSourceCreateImageAtIndex(source, i, NULL);
        //5.根据CGImageRef获取图片
        //[UIScreen mainScreen].scale    是计算屏幕分辨率的
        //UIImageOrientationUp           指定新的图像的绘制方向
        UIImage    * image        = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        //6.释放CGImageRef对象
        CGImageRelease(imageRef);
        /************************** 保存图片 *************************/
        //图片转data
        NSData     * imagedata = UIImagePNGRepresentation(image);
        //图片保存路径 可以jpg或者png
        NSString   * imgpath   = [imagepPath stringByAppendingString:[NSString stringWithFormat:@"/%d.png",i]];
        //将图片写入
        [imagedata writeToFile:imgpath atomically:YES];
        //保存图片路径
        [imgPaths addObject:imgpath];
        // NSDictionary *frameDict = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL);
        //Width = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        //Height = [[frameDict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
    }
    //释放source
    CFRelease(source);
    return imgPaths;
}
/*在每张图片上添加文字 相要gif的背景色是透明  把GIF解析后的每一帧图片实现透明，在合成GIF图片*/
-(NSArray *)getImagesWithText:(NSArray *)arr{
    NSMutableArray * withTextImageArr = [NSMutableArray new];
    for (int index = 0; index < arr.count; index++) {
        UIView      * tempView      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        tempView.backgroundColor    = [UIColor clearColor];
        UIImageView * tempImageView = [[UIImageView alloc] initWithFrame:tempView.bounds];
        tempImageView.image         = [arr objectAtIndex:index];
        [tempView addSubview:tempImageView];
        UILabel     * label         = [[UILabel alloc] initWithFrame:CGRectMake(0, tempView.bounds.size.height-30, tempView.bounds.size.width, 30)];
        label.backgroundColor       = [UIColor clearColor];
        label.textAlignment         = NSTextAlignmentCenter;
        label.textColor             = [UIColor cyanColor];
        label.text                  = @"GIF测试";
        label.font                  = [UIFont boldSystemFontOfSize:30];
        [tempView addSubview:label];
        UIGraphicsBeginImageContextWithOptions(tempView.frame.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context        = UIGraphicsGetCurrentContext();
        [tempView.layer renderInContext:context];//重点
        UIImage * image             = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [withTextImageArr addObject:image];
    }
    return withTextImageArr;
}
- (UIImage *)animatedGIFWithData:(NSData *)data{
    CGImageSourceRef source      = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    if (!source) {
        return nil;
    }
    size_t         count         = CGImageSourceGetCount(source);
    UIImage      * animatedImage;
    float          duration      = 0.0f;
    NSDictionary * options       = @{(__bridge NSString *)kCGImageSourceShouldCache: @(YES), (__bridge NSString *)kCGImageSourceTypeIdentifierHint: (__bridge NSString *)kUTTypeGIF};
    if (count <= 1){
        animatedImage            = [[UIImage alloc] initWithData:data];
    }else {
        NSMutableArray<UIImage *>* images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef           = CGImageSourceCreateImageAtIndex(source, i, (__bridge CFDictionaryRef)options);
            if (!imageRef) {
                continue;
            }
            duration                     += [self durationAtIndex:i source:source];
            [images addObject:[[UIImage alloc] initWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(imageRef);
        }
        animatedImage                     = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}
- (float)durationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source{
    float frameDuration                   = 0.1f;
    CFDictionaryRef cfFrameProperties     = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary * frameProperties        = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary * gifProperties          = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber     * delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration                     = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber * delayTimeProp          = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration                 = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}
@end
/**
//根目录
NSString*homeDir = NSHomeDirectory();
NSString *homeDir = NSHomeDirectoryForUser(NSUserName());
///Users/longxingguo/Library/Developer/CoreSimulator/Devices/7B5CA814-C3CA-4BBE-915C-42CA98FE156A/data/Containers/Data/Application/D6CC244A-03EB-4C67-A402-CDA59643F582
 
// 获取Documents目录路径
NSString*docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
///Users/longxingguo/Library/Developer/CoreSimulator/Devices/7B5CA814-C3CA-4BBE-915C-42CA98FE156A/data/Containers/Data/Application/D6CC244A-03EB-4C67-A402-CDA59643F582/Documents
 
//获取Library的目录路径
NSString*libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) lastObject];
///Users/longxingguo/Library/Developer/CoreSimulator/Devices/7B5CA814-C3CA-4BBE-915C-42CA98FE156A/data/Containers/Data/Application/D6CC244A-03EB-4C67-A402-CDA59643F582/Library
 
// 获取cache目录路径
NSString*cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) firstObject];
///Users/longxingguo/Library/Developer/CoreSimulator/Devices/7B5CA814-C3CA-4BBE-915C-42CA98FE156A/data/Containers/Data/Application/D6CC244A-03EB-4C67-A402-CDA59643F582/Library/Caches
 
// 获取tmp目录路径
NSString*tmpDir =NSTemporaryDirectory();
 /Users/longxingguo/Library/Developer/CoreSimulator/Devices/7B5CA814-C3CA-4BBE-915C-42CA98FE156A/data/Containers/Data/Application/D6CC244A-03EB-4C67-A402-CDA59643F582/tmp/
*/



/*
 1.加载网络图片
 //NSData是用来包装数据的。NSData存储的是二进制数据，屏蔽了数据之间的差异，文本、音频、图像等数据都可用NSData来存储
 NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
 UIImage *image = [UIImage imageWithData:imgData];// 拿到image
 2.加载沙盒图片
 NSString * path = [[self getPath] stringByAppendingString:@"/1.jpg”];// 准备一张照片放进沙盒里
 NSData * imgData =[NSData dataWithContentsOfFile:path];
 UIImage * image = [[UIImage alloc]initWithContentsOfFile:path];
 3.加载项目中的图片
 UIImage * image = [UIImage imageNamed:@"1.jpg"]; // 直接加载
 NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"];
 UIImage * image = [UIImage imageWithContentsOfFile:imagePath];// NSBundle加载
 
 
 NSString * filePath = [NSHomeDirectory() stringByAppendingString:@"/Desktop/test.txt"];
 NSData   * data5 = [[NSData alloc] initWithContentsOfFile:filePath];
 
 NSURL *urlPath = [NSURL URLWithString:[@"file://" stringByAppendingString:[NSHomeDirectory() stringByAppendingString:@"/Desktop/test.txt"]]];
 NSData *data7 = [[NSData alloc] initWithContentsOfURL:urlPath];
 
 NSString *string = @"bei jing nin hao";
 NSData *data9 = [string dataUsingEncoding:NSUTF8StringEncoding];
 NSString *str1 = [[NSString alloc]initWithData:strData encoding:NSUTF8StringEncoding];
 
 NSData *imageData1 = UIImagePNGRepresentation(UIImage *image);     //png 格式
 NSData *imageData2 = UIImageJPEGRepresentation(UIImage *image, CGFloat compressionQuality)  //jpeg格式
 */
