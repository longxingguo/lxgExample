//
//  LXGMasonryView.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGMasonryView.h"
static CGFloat UIDatePickerHeight = 200;
@interface LXGMasonryView ()
@property (nonatomic ,strong)UIView * bgView;
@end
@implementation LXGMasonryView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor redColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(UIDatePickerHeight);
        make.top.mas_equalTo(self.mas_bottom);
    }];
}
- (BOOL)becomeFirstResponder {
    [self layoutIfNeeded];
    CGFloat safeAreaBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaBottom = self.superview.safeAreaInsets.bottom;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom).offset(- UIDatePickerHeight - safeAreaBottom);
            make.height.mas_equalTo(UIDatePickerHeight + safeAreaBottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    return [super resignFirstResponder];
}
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) return ;
    [self becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.anyObject.view == self) {
        [self resignFirstResponder];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}
@end
