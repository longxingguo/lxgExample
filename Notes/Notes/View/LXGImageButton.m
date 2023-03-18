//
//  LXGImageButton.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/18.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGImageButton.h"
@implementation LXGImageButton
//图片在上
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state topSpacing:(CGFloat)Spacing{
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
//图片在左
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state leftSpacing:(CGFloat)Spacing{
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
//图片在下
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state bottomSpacing:(CGFloat)Spacing{
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
//图片在右
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state rightSpacing:(CGFloat)Spacing{
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
@end
/*
 以button宽高为基准 image frame会根据1x坐标计算*/
