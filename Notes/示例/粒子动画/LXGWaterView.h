//
//  LXGWaterView.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/16.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LXGBorderPathType){
    LXGBorderPathType_normal = 0,//正常
    LXGBorderPathType_heart  = 1,//心型
    LXGBorderPathType_circle = 2,//圆形
    LXGBorderPathType_stars  = 3,//星星
};
@interface LXGWaterView : UIView
//容器边界类型
@property (nonatomic, assign) LXGBorderPathType type;
//边界path，水波的容器
@property (nonatomic, strong) UIBezierPath    * borderPath;
//容器填充色
@property (nonatomic, strong) UIColor         * borderFillColor;
//容器描边色
@property (nonatomic, strong) UIColor         * borderStrokeColor;
//容器描边宽度
@property (nonatomic, assign) CGFloat           borderWidth;
//前方波纹颜色
@property (nonatomic, strong) UIColor         * topColor;
//后方波纹颜色
@property (nonatomic, strong) UIColor         * bottomColor;
//y = asin(wx+φ) + k
//振幅，a
@property (nonatomic, assign) CGFloat           amplitude;
//周期，w
@property (nonatomic, assign) CGFloat           cycle;
//两个波水平之间偏移
@property (nonatomic, assign) CGFloat           hDistance;
//两个波竖直之间偏移
@property (nonatomic, assign) CGFloat           vDistance;
//水波速率
@property (nonatomic, assign) CGFloat           scale;
//进度,计算k
@property (nonatomic, assign) CGFloat           progress;
-(void)beginAnimation;
-(void)endAnimation;
@end
