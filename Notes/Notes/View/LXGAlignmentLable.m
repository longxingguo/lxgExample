//
//  LXGAlignmentLable.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/9/6.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGAlignmentLable.h"
@implementation LXGAlignmentLable
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.textAlignment = LXGAlignment_Middle;
    }
    return self;
}
-(void)setStyleAlignment:(LXGAlignment)styleAlignment{
    _styleAlignment = styleAlignment;
    [self setNeedsDisplay];
}
-(void)drawTextInRect:(CGRect)rect{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.styleAlignment){
        case LXGAlignment_Top:{//上
            textRect.origin.y = bounds.origin.y;
        }break;
        case LXGAlignment_Middle:{//中
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
        }break;
        case LXGAlignment_Bottom:{//下
            textRect.origin.y = bounds.origin.y + bounds.size.height  - textRect.size.height;
        }break;
        default:
         break;
    }
    return textRect;
}
@end
