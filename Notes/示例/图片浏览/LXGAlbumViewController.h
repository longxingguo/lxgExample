//
//  LXGAlbumViewController.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXGAlbumViewController : UIViewController
/// 确定事件
@property (nonatomic, copy) void(^AlbumConfirmAction)(void);

@end

NS_ASSUME_NONNULL_END
