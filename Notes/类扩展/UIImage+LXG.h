//
//  UIImage+LXG.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LXG)
- (UIImage *)removeColorWithMaxR:(float)maxR minR:(float)minR maxG:(float)maxG minG:(float)minG maxB:(float)maxB minB:(float)minB;
- (UIImage *)removeColorMaxR:(float)maxR minR:(float)minR maxG:(float)maxG minG:(float)minG maxB:(float)maxB minB:(float)minB;
- (UIImage *)maskImage;
/**
 图片旋转
 @param angle 旋转角度 0-360
 @return UIImage
 */
-(UIImage *)rotateAngle:(CGFloat)angle;
/**
 加边框
 @param name 图片名字
 @param size 大小
 @param borderWidth 边框宽
 @param borderColor 边框颜色
 @return UIImage
 */
-(UIImage *)circleName:(NSString *)name andSize:(CGSize)size andborderWidth:(CGFloat)borderWidth andborderColor:(UIColor *)borderColor;
/**
 图片拉伸
 @param edgeInsets 可拉伸区域
 @return UIImage
 */
-(UIImage *)tensile:(UIEdgeInsets)edgeInsets;
//

@end

NS_ASSUME_NONNULL_END
