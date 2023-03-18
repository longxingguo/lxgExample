//
//  LXGAlignmentLable.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/9/6.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,LXGAlignment) {
    LXGAlignment_Top    = 0,//上
    LXGAlignment_Middle = 1,//中
    LXGAlignment_Bottom = 2,//下
};
NS_ASSUME_NONNULL_BEGIN
@interface LXGAlignmentLable : UILabel
@property (nonatomic, assign) LXGAlignment styleAlignment;
@end
NS_ASSUME_NONNULL_END
