//
//  LXGDateTool.h
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LXGDateTool : NSObject
+ (instancetype)sharedDateTool;
///1 获取当前时间 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDate;
///2 根据自己的时间格式获取当前时间
-(NSString *)getNowDateWithFormatter:(NSString *)formatter;
///3 获取当前时间戳 精确到秒
-(long)getNowDateLong;
///4 获取当前时间戳 精确到毫秒
-(long long)getNowDateLongLong;
///5 当前时间向前推多少个小时 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToPastDateWithHour:(NSInteger)hour;
///6 当前时间向前推多少个小时取整点 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToPastWholeClockDateWithHour:(NSInteger)hour;
///7 当前时间向后推多少个小时 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToFutureDateWithHour:(NSInteger)hour;
///8 当前时间向后推多少个小时取整点 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToFutureWholeClockDateWithHour:(NSInteger)hour;
///9 当前时间向后推24小时的数组 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getHourFuture24:(NSString *)timeStr;
///10 当前时间向后推7天的数组 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getDayFuture7:(NSString *)timeStr;
///11 当前时间获取后7天几月几号 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)get7DayWithString:(NSString *)timeStr;
///12 当前时间获取后7天几月几号 比11的基础上多0 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getZero7DayWithString:(NSString *)timeStr;
///13 今天 明天 周几 周几 周几 周几 周几 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getWeekWithString:(NSString *)timeStr;
///14 目标时间与当前时间差 timeStr:yyyy-MM-dd HH:mm:ss
- (NSString *)getTimedifferenceWithString:(NSString *)timeString;
///15 昨天晚上8点 今天早上8点
-(NSString *)getTodayOrYesterdayTime;
///16 传入的时间和时间格式获取 formatter 目标格式 timeStr:yyyy-MM-dd HH:mm:ss
-(NSString *)getStringWithFormatter:(NSString *)formatter andTimeString:(NSString *)timeStr;
///17 时间戳获取时间 second 时间戳 IsSecond YES表示秒 NO 表示毫秒
-(NSString * )getNowDateWithSecond:(long long)second andIsSecond:(BOOL)isSecond;
///18 获取上旬 中旬 下旬
-(NSString * )getTenDay;
///19时间比较
-(BOOL)getValidWithform:(NSString *)ftimeStr andValid:(double)hour andTo:(NSString *)ttimeStr;
@end
NS_ASSUME_NONNULL_END
