//
//  ProgressBarView.h
//  LXGDemo合集
//
//  Created by onecar on 2018/11/20.
//  Copyright © 2018年 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProgressBarView : UIView
//底层颜色
@property (nonatomic ,strong)UIColor *  underColor;
//上层颜色
@property (nonatomic ,strong)UIColor *  upperColor;
//宽
@property (nonatomic ,assign)CGFloat    lineWidth;
//进度(0-1)之间
@property (nonatomic ,assign)CGFloat    proGress;
@end
