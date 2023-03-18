//
//  LXGBrowseViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGBrowseViewController.h"
#import "LXGAlbumManager.h"
@interface LXGBrowseViewController ()

@end

@implementation LXGBrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * Button      = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 50, 50)];
    Button.backgroundColor = [UIColor redColor];
    [Button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Button];
}
-(void)click{
    [LXGAlbumManager showPhotosManager:self withMaxImageCount:10 withAlbumArray:^(NSMutableArray<LXGPhotoModel *> * _Nonnull albumArray) {
        
    }];
}
@end
