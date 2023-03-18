//
//  LXGEmbeddedLable.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/17.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGEmbeddedLable : UIView
//上 默认5
@property (nonatomic ,assign)double            top;
//左 默认5
@property (nonatomic ,assign)double            left;
//右 默认5
@property (nonatomic ,assign)double            right;
//下 默认5
@property (nonatomic ,assign)double            bottom;
//大小
@property (nonatomic ,assign)double            textfont;
//圆角
@property (nonatomic ,assign)double            cornerRadius;
//行数
@property (nonatomic ,assign)int               numberOfLines;
//对齐方式
@property (nonatomic ,assign)NSTextAlignment   textAlignment;
//文字
@property (nonatomic ,copy  )NSString        * text;
//颜色
@property (nonatomic ,strong)UIColor         * textColor;
//模式
@property (nonatomic ,assign)NSLineBreakMode   lineBreakMode;
@end
NS_ASSUME_NONNULL_END
