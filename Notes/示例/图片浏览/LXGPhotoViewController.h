//
//  LXGPhotoViewController.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/22.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXGAlbumModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LXGPhotoViewController : UIViewController
@property (nonatomic ,strong) LXGAlbumModel * model;
@property (nonatomic ,strong) void(^sureSelect)(void);
@end

NS_ASSUME_NONNULL_END
