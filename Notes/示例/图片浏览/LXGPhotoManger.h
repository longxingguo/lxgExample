//
//  LXGPhotoManger.h
//  LXGDemo合集
//
//  Created by onecar on 2019/4/18.
//  Copyright © 2019 onecar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXGPhotoModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^LXGPhotoMangerChoiceCountChange)(NSInteger choiceCount);
@interface LXGPhotoManger : NSObject
/// 可选的的最大数量
@property (nonatomic, assign) NSInteger maxCount;
/// 已选数量
@property (nonatomic, assign) NSInteger choiceCount;
/// 已选图片
@property (nonatomic, strong) NSMutableArray<LXGPhotoModel *> *photoModelList;
/// 选择图片变化
@property (nonatomic, copy) LXGPhotoMangerChoiceCountChange choiceCountChange;

/**
 单例
 
 @return 返回对象
 */
+(LXGPhotoManger*)standardPhotoManger;
@end

NS_ASSUME_NONNULL_END
