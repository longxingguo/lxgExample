//
//  HorizontalLayout.h
//  Notes
//
//  Created by 龙兴国 on 2020/7/31.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface HorizontalLayout : UICollectionViewFlowLayout
//一行中 cell 的个数
@property (nonatomic,assign) NSUInteger itemCountPerRow;
//一页显示多少行
@property (nonatomic,assign) NSUInteger rowCount;
@end
NS_ASSUME_NONNULL_END
