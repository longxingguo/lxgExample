//
//  UIButton+LXG.h
//  Notes
//
//  Created by 龙兴国 on 2019/11/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ButtonImageType) {
    ButtonImageType_top    = 0,//上
    ButtonImageType_left   = 1,//左
    ButtonImageType_bottom = 2,//下
    ButtonImageType_right  = 3,//右
};
NS_ASSUME_NONNULL_BEGIN
@interface UIButton (LXG)
//图片在左
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing;
//图片在右
- (void)setIconInRightWithSpacing:(CGFloat)Spacing;
//图片在上
- (void)setIconInTopWithSpacing:(CGFloat)Spacing;
//图片在下
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing;
//必须先给frame
- (void)setTitle:(NSString *)title andImage:(NSString *)image andSelectImage:(NSString *)selectImage andTopLeftRightBottom:(ButtonImageType)type andSpacing:(CGFloat)spacing andFont:(CGFloat)font AndBackgroundColor:(UIColor *)backgroundColor;
@end

NS_ASSUME_NONNULL_END
