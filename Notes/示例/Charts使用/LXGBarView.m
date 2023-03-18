//
//  LXGBarView.m
//  Notes
//
//  Created by 龙兴国 on 2020/8/20.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import "LXGBarView.h"
@interface LXGBarView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * collectionView;
@end
@implementation LXGBarView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection     = UICollectionViewScrollDirectionHorizontal;
    self.collectionView            = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width - 20, self.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
}
@end
