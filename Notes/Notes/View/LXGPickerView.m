//
//  LXGPickerView.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGPickerView.h"
CGFloat    const pickerViewHeigh = 200;
@interface LXGPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
//背景
@property (nonatomic , strong) UIView * bgView;
//标题背景
@property (nonatomic , strong) UIView * bgTitleView;
//取消
@property (nonatomic , strong) UIButton * cancleButton;
//标题
@property (nonatomic , strong) UILabel  * titleLable;
//确定
@property (nonatomic , strong) UIButton * sureButton;
//选择器
@property (nonatomic , strong) UIPickerView * pickerView;
//数据源
@property (nonatomic , strong) NSArray      * rowsArray;
//存储block
@property (nonatomic , copy  ) void(^completehandle)(NSArray * selectedIndexes ,NSString * resultStr);
//选中数组
@property (nonatomic , strong) NSMutableArray * selectRowIndexArray;
@end
static LXGPickerView * _pickerView ;
@implementation LXGPickerView
+ (void)showPickerTitle:(NSString *)title andRowsArray:(NSArray *)rowsArray andCompleteHandle:(void(^)(NSArray * selectedIndexes ,NSString * resultStr))completehandle{
    _pickerView                = [[LXGPickerView alloc]initWithFrame:[[UIScreen mainScreen] bounds] withTitle:(NSString *)title andRowsArray:rowsArray];
    _pickerView.completehandle = completehandle;
    [[UIApplication sharedApplication].keyWindow addSubview:_pickerView];
    [_pickerView show];
}
-(void)show{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        if (@available(iOS 11.0, *)) {
            self.bgView.frame = CGRectMake(0, self.bounds.size.height - pickerViewHeigh - self.safeAreaInsets.bottom , self.bounds.size.width, pickerViewHeigh + self.safeAreaInsets.bottom);
        } else {
            self.bgView.frame = CGRectMake(0, self.bounds.size.height - pickerViewHeigh , self.bounds.size.width, pickerViewHeigh);
        }
    }];
}
- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor  = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            self.bgView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, pickerViewHeigh + self.safeAreaInsets.bottom);
        } else {
            self.bgView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, pickerViewHeigh);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch     = [touches anyObject];
    UIView  * touchview = touch.view;
    if ([touchview isKindOfClass:[self class]]){
        [self hide];
    }
}
#pragma mark 生命周期
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title andRowsArray:(NSArray *)rowsArray{
    if (self = [super initWithFrame:frame]){
        self.rowsArray = rowsArray;
        for (int i = 0; i < self.rowsArray.count; i++) {
            [self.selectRowIndexArray addObject:[NSNumber numberWithInteger:0]];
        }
        [self creatUIWithTitle:title];
    }
    return self ;
}
- (void)creatUIWithTitle:(NSString *)title{
    //白色背景
    self.bgView                 = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, pickerViewHeigh)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    //标题背景
    self.bgTitleView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    self.bgTitleView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    [self.bgView addSubview:self.bgTitleView];
    //取消按钮
    self.cancleButton                 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.bgTitleView addSubview:self.cancleButton];
    //标题
    self.titleLable               = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, self.bounds.size.width - 100, 20)];
    self.titleLable.text          = title;
    self.titleLable.font          = [UIFont systemFontOfSize:16];
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.bgTitleView addSubview:self.titleLable];
    //确定
    self.sureButton                 = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 50, 10, 40, 20)];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithRed:209/255.0 green:176/255.0 blue:94/255.0 alpha:1] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgTitleView addSubview:self.sureButton];
    //选择器
    self.pickerView            = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, pickerViewHeigh - 40)];
    self.pickerView.delegate   = self;
    self.pickerView.dataSource = self;
    [self.bgView addSubview:self.pickerView];
}
-(void)sureButtonClick{
    if (self.completehandle) {
        NSString * str = @"";
        for (NSInteger i = 0; self.selectRowIndexArray.count; i++) {
            NSNumber * number = self.selectRowIndexArray[i];
            NSString * rowStr = [self pickerView:self.pickerView titleForRow:number.integerValue forComponent:i];
            [str stringByAppendingString:rowStr];
        }
        self.completehandle(self.selectRowIndexArray,str);
    }
}
#pragma mark  UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.rowsArray.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray * rowArray = self.rowsArray[component];
    return rowArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray * rowArray = self.rowsArray[component];
    return  rowArray[row];
}
-(NSString *)getTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray  * rowArray = self.rowsArray[component];
    NSString * str      = nil;
    for (int i = 0; i < rowArray.count; i ++) {
        id unkonw = rowArray[row];
        if ([unkonw isKindOfClass:NSString.class]){
            str= (NSString *)unkonw;
            break;
        }
        if ([unkonw isKindOfClass:NSNumber.class]){
            str= [(NSNumber *)unkonw stringValue] ;
            break;
        }
    }
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.selectRowIndexArray replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for(UIView * singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = [UIColor lightGrayColor];
        }
    }
    UILabel * pickerLabel      = [[UILabel alloc] init];
    pickerLabel.textAlignment  = NSTextAlignmentCenter;
    pickerLabel.textColor      = [UIColor blackColor];
    pickerLabel.font           = [UIFont systemFontOfSize:16];
    pickerLabel.text           = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(NSMutableArray *)selectRowIndexArray{
    if(!_selectRowIndexArray){
        _selectRowIndexArray = [NSMutableArray array];
    }
    return _selectRowIndexArray;
}
@end
//-(void)didMoveToSuperview{
//    [super didMoveToSuperview];
//    if (self.superview == nil) {
//        return;
//    }
//    [self show];
//}
