//
//  ProgressView.h
//  LXGDemo合集
//
//  Created by onecar on 2018/11/30.
//  Copyright © 2018年 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
//底层颜色
@property (nonatomic ,strong)UIColor *  underColor;
//底层填充颜色
@property (nonatomic ,strong)UIColor *  underFillColor;
//上层颜色
@property (nonatomic ,strong)UIColor *  upperColor;
//上层填充颜色
@property (nonatomic ,strong)UIColor *  upperFillColor;
//底层宽
@property (nonatomic ,assign)CGFloat    unlineWidth;
//上层宽
@property (nonatomic ,assign)CGFloat    uplineWidth;
//进度(0-1)之间
@property (nonatomic ,assign)CGFloat    proGress;
@end
