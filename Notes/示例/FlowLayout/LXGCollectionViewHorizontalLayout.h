//
//  LXGCollectionViewHorizontalLayout.h
//  fzweather
//
//  Created by 龙兴国 on 2020/7/30.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGCollectionViewHorizontalLayout : UICollectionViewFlowLayout
- (instancetype)initWithItemCountPerRow:(NSInteger)itemCountPerRow
maxRowCount:(NSInteger)maxRowCount;
@end
NS_ASSUME_NONNULL_END
