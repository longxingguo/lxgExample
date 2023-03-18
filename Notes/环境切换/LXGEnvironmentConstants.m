//
//  LXGEnvironmentConstants.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//
#import "LXGEnvironmentConstants.h"
NSString  * BaseURLString;
NSString  * H5BaseURLString;
void setBaseURL(void){
    BaseURLString   = @"正式环境";
    H5BaseURLString = @"正式环境";
#if DEBUG
    NSNumber * environmentNumber  = [[NSUserDefaults standardUserDefaults]objectForKey:@"EnvironmentNumber"];
    NSInteger  environmentInteger = environmentNumber.integerValue;
    switch (environmentInteger) {
        case 0:{//正式环境
            BaseURLString   = @"正式环境";
            H5BaseURLString = @"正式环境";
        }break;
        case 1:{//测试环境
            BaseURLString   = @"测试环境";
            H5BaseURLString = @"测试环境";
        }break;
        case 2:{//开发环境
            BaseURLString   = @"开发环境";
            H5BaseURLString = @"开发环境";
        }break;
        default:
            break;
    }
#else
#endif
}
