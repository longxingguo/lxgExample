//
//  LXGTextField.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/28.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGTextField : UITextField
@property (nonatomic ,strong)UIColor * placeholderColor;
@property (nonatomic ,assign)NSInteger maxLength;
@end
NS_ASSUME_NONNULL_END
