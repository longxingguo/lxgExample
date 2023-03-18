//
//  LXGEmbeddedLable.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/17.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGEmbeddedLable.h"
#import <Masonry/Masonry.h>
@interface LXGEmbeddedLable ()
@property (nonatomic ,strong)UILabel * titleLable;
@end
@implementation LXGEmbeddedLable
- (instancetype)init{
    if (self = [super init]){
        self.top             = 5.0;;
        self.left            = 5.0;
        self.right           = 5.0;
        self.bottom          = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.titleLable = [[UILabel alloc]init];
    [self addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.top);
        make.left.equalTo(self).offset(self.left);
        make.right.equalTo(self).offset(-self.right);
    }];
}
-(void)setTextfont:(double)textfont{
    self.titleLable.font          = [UIFont systemFontOfSize:textfont];
}
-(void)setCornerRadius:(double)cornerRadius{
    self.layer.cornerRadius       = cornerRadius;
}
-(void)setNumberOfLines:(int)numberOfLines{
    self.titleLable.numberOfLines = numberOfLines;
}
-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    self.titleLable.textAlignment = textAlignment;
}
-(void)setText:(NSString *)text{
    self.titleLable.text          = text;
}
-(void)setTextColor:(UIColor *)textColor{
    self.titleLable.textColor     = textColor;
}
-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    self.titleLable.lineBreakMode = lineBreakMode;
}
-(void)updateConstraints{
    [super updateConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLable.mas_bottom).offset(self.bottom);
    }];
}
@end
