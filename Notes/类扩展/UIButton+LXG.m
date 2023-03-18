//
//  UIButton+LXG.m
//  Notes
//
//  Created by 龙兴国 on 2019/11/5.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "UIButton+LXG.h"
@implementation UIButton (LXG)
//图片在左
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing{
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = Spacing/2,
        .bottom = 0,
        .right  = -Spacing/2,
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = -Spacing/2,
        .bottom = 0,
        .right  = Spacing/2,
    };
}
//图片在右
- (void)setIconInRightWithSpacing:(CGFloat)Spacing{
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   = - (img_W + Spacing / 2),
        .bottom = 0,
        .right  =   (img_W + Spacing / 2),
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = 0,
        .left   =   (tit_W + Spacing / 2),
        .bottom = 0,
        .right  = - (tit_W + Spacing / 2),
    };
}
//图片在上
- (void)setIconInTopWithSpacing:(CGFloat)Spacing{
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat img_H = self.imageView.frame.size.height;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    CGFloat tit_H = self.titleLabel.frame.size.height;
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    =   (tit_H / 2 + Spacing / 2),
        .left   = - (img_W / 2),
        .bottom = - (tit_H / 2 + Spacing / 2),
        .right  =   (img_W / 2),
    };
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    = - (img_H / 2 + Spacing / 2),
        .left   =   (tit_W / 2),
        .bottom =   (img_H / 2 + Spacing / 2),
        .right  = - (tit_W / 2),
    };
}
//图片在下
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing{
    CGFloat img_W = self.imageView.frame.size.width;
    CGFloat img_H = self.imageView.frame.size.height;
    CGFloat tit_W = self.titleLabel.frame.size.width;
    CGFloat tit_H = self.titleLabel.frame.size.height;
    
    self.titleEdgeInsets = (UIEdgeInsets){
        .top    = - (tit_H / 2 + Spacing / 2),
        .left   = - (img_W / 2),
        .bottom =   (tit_H / 2 + Spacing / 2),
        .right  =   (img_W / 2),
    };
    
    self.imageEdgeInsets = (UIEdgeInsets){
        .top    =   (img_H / 2 + Spacing / 2),
        .left   =   (tit_W / 2),
        .bottom = - (img_H / 2 + Spacing / 2),
        .right  = - (tit_W / 2),
    };
}
- (void)setTitle:(NSString *)title andImage:(NSString *)image andSelectImage:(NSString *)selectImage andTopLeftRightBottom:(ButtonImageType)type andSpacing:(CGFloat)spacing andFont:(CGFloat)font AndBackgroundColor:(UIColor *)backgroundColor{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.layer.cornerRadius         = 5.0;
    self.titleLabel.font            = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.backgroundColor            = [UIColor whiteColor];
    if (title.length) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (image.length) {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (selectImage.length) {
        [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
    }
    if (font>0) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:font];
    }
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
    if (type == ButtonImageType_top) {
        [self setIconInTopWithSpacing:spacing];
    }
    if (type == ButtonImageType_left) {
        [self setIconInLeftWithSpacing:spacing];
    }
    if (type == ButtonImageType_bottom) {
        [self setIconInBottomWithSpacing:spacing];
    }
    if (type == ButtonImageType_right) {
        [self setIconInRightWithSpacing:spacing];
    }
}
@end
