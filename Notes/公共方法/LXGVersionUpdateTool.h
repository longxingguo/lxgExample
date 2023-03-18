//
//  LXGVersionUpdateTool.h
//  ShanXiNongYe
//
//  Created by 龙兴国 on 2020/6/29.
//  Copyright © 2020 龙兴国. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGVersionUpdateTool : NSObject
@property(nonatomic,assign)BOOL isshow;
+(instancetype)shareVersionUpdateTool;
-(void)checkVersionUpdate;
@end
NS_ASSUME_NONNULL_END
