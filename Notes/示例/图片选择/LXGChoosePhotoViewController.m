//
//  LXGChoosePhotoViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGChoosePhotoViewController.h"

@interface LXGChoosePhotoViewController ()

@end

@implementation LXGChoosePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIButton * Button      = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 50, 50)];
//    Button.backgroundColor = [UIColor redColor];
//    [Button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:Button];
    self.view.backgroundColor = [UIColor redColor];
    
    UIView * eview = [[UIView alloc]initWithFrame:self.view.frame];
    eview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:eview];
    [LXGPublicTool effectView:eview andStyle:UIBlurEffectStyleExtraLight];
}
-(void)click{
    [LXGPhotoTool  getPhotoWithPhotoNumber:9 AllowCrop:NO andComplete:^(NSArray * _Nonnull imageArray) {
        
    }];
    
}

@end
