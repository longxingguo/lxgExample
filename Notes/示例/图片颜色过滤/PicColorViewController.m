//
//  PicColorViewController.m
//  Notes
//
//  Created by 龙兴国 on 2020/8/10.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import "PicColorViewController.h"
#import "UIImage+LXG.h"
#import "Notes-Swift.h"
@interface PicColorViewController ()
@property (nonatomic ,strong)UIImageView * left;
@property (nonatomic ,strong)UIImageView * right;
@end

@implementation PicColorViewController

- (void)viewDidLoad {
//    self.view.backgroundColor = [UIColor redColor];
    [super viewDidLoad];
    self.left = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 200, 200)];
    [self.view addSubview:self.left];
    self.right = [[UIImageView alloc]initWithFrame:CGRectMake(0, 310, 200, 200)];
   // self.right.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.right];
    
//    self.left.image  = LColorImage(@"0xff00EBEB");
//    self.right.image = [self.left.image maskImage];
    
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/10/2008101424_060.png"] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (image){
//            self.left.image  = image;
//            self.right.image = [image removeColorWithMaxR:0 minR:30 maxG:230 minG:240 maxB:230 minB:240];
//        }
//    }];
    
    self.left.image  = [UIImage imageNamed:@"2008171642_000"];
    self.right.image = [[UIImage imageNamed:@"2008171642_000"] removeColorWithMaxR:0 minR:0 maxG:235 minG:235 maxB:235 minB:235];
}
@end
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171554_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171600_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171606_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171612_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171618_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171624_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171630_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171636_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171642_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUP_RADDATA2_P/2020/08/17/2008171648_000.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_006.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_012.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_018.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_024.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_030.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_036.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_042.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_048.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_054.png,
//http://wdy.fzqxj.cn:2001/Files/Weather/RAD/Product/GrADS/PUPYB_RADDATA2_P/2020/08/17/2008171648_060.png
