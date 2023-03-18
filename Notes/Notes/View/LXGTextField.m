//
//  LXGTextField.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGTextField.h"
@implementation LXGTextField
//颜色
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    if (self.placeholder.length){
        NSAttributedString * attr  = [[NSAttributedString alloc]initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor,NSFontAttributeName:self.font}];
        self.attributedPlaceholder = attr;
    }
}
//长度
- (void)setMaxLength:(NSInteger)maxLength{
    if (maxLength > 0) {
        [self addTarget:self action:@selector(editingTextFiled:) forControlEvents:UIControlEventAllEditingEvents];
    } else {
        [self removeTarget:self action:@selector(editingTextFiled:) forControlEvents:UIControlEventAllEditingEvents];
    }
}
//计算
- (void)editingTextFiled:(UITextField *)textField {
    NSString * toBeString = textField.text;
    if(self.maxLength > 0){
        //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
        NSString * lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
        if([lang isEqualToString:@"zh-Hans"] || [lang isEqualToString:@"zh-Hant"]){//中文输入 + 繁体中文
            UITextRange    * selectedRange = [textField markedTextRange];//获取高亮部分
            UITextPosition * position      = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position){//没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if(toBeString.length > self.maxLength){
                    textField.text = [toBeString substringToIndex:self.maxLength];
                    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
                }
            }else{}//有高亮选择的字符串，则暂不对文字进行统计和限制
        }else {//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > self.maxLength) {
                textField.text = [toBeString substringToIndex:self.maxLength];
                [textField sendActionsForControlEvents:UIControlEventEditingChanged];
            }
        }
    }
}
@end
