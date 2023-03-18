//
//  UIView+LXG.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIView (LXG)
//frame.origin.x
@property (nonatomic,assign) CGFloat left;
//frame.origin.y
@property (nonatomic,assign) CGFloat top;
//frame.origin.x + frame.size.width
@property (nonatomic,assign) CGFloat right;
//frame.origin.y + frame.size.height
@property (nonatomic,assign) CGFloat bottom;
//frame.size.width.
@property (nonatomic,assign) CGFloat width;
//frame.size.height.
@property (nonatomic,assign) CGFloat height;
//center.x
@property (nonatomic,assign) CGFloat centerX;
//center.y
@property (nonatomic,assign) CGFloat centerY;
//frame.origin.
@property (nonatomic,assign) CGPoint origin;
//frame.size.
@property (nonatomic,assign) CGSize  size;
@end
NS_ASSUME_NONNULL_END
