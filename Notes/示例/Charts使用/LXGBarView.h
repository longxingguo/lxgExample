//
//  LXGBarView.h
//  Notes
//
//  Created by 龙兴国 on 2020/8/20.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class LXGBarView;
@protocol LXGBarViewDelegate <NSObject>
- (void)LXGBarView:(LXGBarView *)barView selectIndex:(NSInteger)index;
@end
@interface LXGBarView : UIView
@property (nonatomic, weak  )id<LXGBarViewDelegate> delegate;
@property (nonatomic, strong)NSArray * dataarray;

@end
NS_ASSUME_NONNULL_END
