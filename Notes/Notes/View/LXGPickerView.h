//
//  LXGPickerView.h
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGPickerView : UIView
/**
 选择器
 @param title 标题
 @param rowsArray 数组 支持多组(数组里装数组)最里层是字符或者number类型
 @param completehandle 返回选择文字和选中的下标 selectedIndexes 对应component里选中的row下标
 */
+(void)showPickerTitle:(NSString *)title andRowsArray:(NSArray *)rowsArray andCompleteHandle:(void(^)(NSArray * selectedIndexes ,NSString * resultStr))completehandle;
@end
NS_ASSUME_NONNULL_END
