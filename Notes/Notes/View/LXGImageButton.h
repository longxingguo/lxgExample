//
//  LXGImageButton.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/18.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGImageButton : UIButton
//图片在上
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state topSpacing:(CGFloat)Spacing;
//图片在左
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state leftSpacing:(CGFloat)Spacing;
//图片在下
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state bottomSpacing:(CGFloat)Spacing;
//图片在右
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state rightSpacing:(CGFloat)Spacing;
@end
NS_ASSUME_NONNULL_END
