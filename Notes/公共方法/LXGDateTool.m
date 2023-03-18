//
//  LXGDateTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/1.
//  Copyright © 2019 龙兴国. All rights reserved.
//
#pragma mark 常用格式
/*
 y    ==yyy==yyyy
 yy   以带前导零的两位数字格式显示年份--如2009  显示为09
 yyy  ==yyyy
 yyyy 以四位数字格式显示年份--如2009
 M    将月份显示为不带前导零的数字--如一月表示为 1
 MM   将月份显示为带前导零的数字--如 01  12   09
 MMM  将月份显示为缩写形式--如 Jan
 MMMM 将月份显示为完整月份名--如 January
 d    将日显示为不带前导零的数字--如 1
 dd   将日显示为带前导零的数字--如 01
 EEE  将日显示为缩写形式--如 Sun
 EEEE 将日显示为全名--如 Sunday
 h    使用 12 小时制将小时显示为不带前导零的数字--如 1:15:15 PM
 hh   使用 12 小时制将小时显示为带前导零的数字--如 01:15:15 PM
 H    使用 24 小时制将小时显示为不带前导零的数字--如 1:15:15
 HH   使用 24 小时制将小时显示为带前导零的数字--如 01:15:15
 m    将分钟显示为不带前导零的数字--如 12:1:15
 mm   将分钟显示为带前导零的数字--如 12:01:15
 s    将秒显示为不带前导零的数字--如 12:15:5
 ss   将秒显示为带前导零的数字--如 12:15:05
 */
#import "LXGDateTool.h"
@interface LXGDateTool ()
@property (nonatomic, strong)NSDateFormatter  * dateFormatter;
@property (nonatomic, strong)NSCalendar       * calendar;
@end
@implementation LXGDateTool
+ (instancetype)sharedDateTool{
    static LXGDateTool    * dateTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateTool = [[LXGDateTool alloc]init];
    });
    return dateTool;
}
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter            = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}
-(NSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}
///1 获取当前时间 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDate{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [self.dateFormatter stringFromDate:[NSDate date]];
}
///2 根据自己的时间格式获取当前时间
-(NSString *)getNowDateWithFormatter:(NSString *)formatter{
    self.dateFormatter.dateFormat = formatter;
    return [self.dateFormatter stringFromDate:[NSDate date]];
}
///3 获取当前时间戳 精确到秒
-(long)getNowDateLong{
    return [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]longValue];
}
///4 获取当前时间戳 精确到毫秒
-(long long)getNowDateLongLong{
    return [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000]longLongValue];
}
///5 当前时间向前推多少个小时 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToPastDateWithHour:(NSInteger)hour{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval  nowTime       = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval  passTime      = nowTime - hour * 3600;
    NSDate        * date          = [NSDate dateWithTimeIntervalSince1970:passTime];
    return [self.dateFormatter stringFromDate:date];
}
///6 当前时间向前推多少个小时取整点 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToPastWholeClockDateWithHour:(NSInteger)hour{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:00:00";
    NSTimeInterval  nowTime       = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval  passTime      = nowTime - hour * 3600;
    NSDate        * date          = [NSDate dateWithTimeIntervalSince1970:passTime];
    return [self.dateFormatter stringFromDate:date];
}
///7 当前时间向后推多少个小时 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToFutureDateWithHour:(NSInteger)hour{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSTimeInterval  nowTime       = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval  passTime      = nowTime + hour * 3600;
    NSDate        * date          = [NSDate dateWithTimeIntervalSince1970:passTime];
    return [self.dateFormatter stringFromDate:date];
}
///8 当前时间向后推多少个小时取整点 yyyy-MM-dd HH:mm:ss
-(NSString *)getNowDateToFutureWholeClockDateWithHour:(NSInteger)hour{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:00:00";
    NSTimeInterval  nowTime       = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval  passTime      = nowTime + hour * 3600;
    NSDate        * date          = [NSDate dateWithTimeIntervalSince1970:passTime];
    return [self.dateFormatter stringFromDate:date];
}
///9 目标时间向后推24小时的数组 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getHourFuture24:(NSString *)timeStr{
    self.dateFormatter.dateFormat   = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * nowdate      = [self.dateFormatter dateFromString:timeStr];
    NSTimeInterval     nowTime      = [nowdate timeIntervalSince1970];
    NSMutableArray   * hourarray    = [NSMutableArray array];
    for (int i = 0; i<=24; i++){
        NSTimeInterval hourTime     = nowTime + i * 3600;
        NSDate       * date         = [NSDate dateWithTimeIntervalSince1970:hourTime];
        [hourarray addObject:[self.dateFormatter stringFromDate:date]];
    }
    return hourarray;
}
///10 当前时间向后推7天的数组 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getDayFuture7:(NSString *)timeStr{
    self.dateFormatter.dateFormat   = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * nowdate      = [self.dateFormatter dateFromString:timeStr];
    NSTimeInterval     nowTime      = [nowdate timeIntervalSince1970];
    NSMutableArray   * dayarray     = [NSMutableArray array];
    for (int i=0;i<=7;i++){
        NSTimeInterval dayTime       = nowTime + i * 24 * 3600;
        NSDate       * date          = [NSDate dateWithTimeIntervalSince1970:dayTime];
        [dayarray addObject:[self.dateFormatter stringFromDate:date]];
    }
    return dayarray;
}
///11 当前时间获取后7天几月几号 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)get7DayWithString:(NSString *)timeStr{
    self.dateFormatter.dateFormat   = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * nowdate      = [self.dateFormatter dateFromString:timeStr];
    NSDateComponents * nowcomps     = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowdate];
    NSInteger          nowMonth     = nowcomps.month;
    NSInteger          nowDay       = nowcomps.day;
    NSInteger          nowMonthDay  = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowdate].length;
    NSMutableArray   * dayarray     = [NSMutableArray array];
    for (int i=0;i<7;i++){
        if (nowDay + i <= nowMonthDay){
            NSString * str = [NSString stringWithFormat:@"%ld/%ld",(long)nowMonth,nowDay + i];
            [dayarray addObject:str];
        }else{
            if (nowMonth + 1 <= 12) {
                NSString * str = [NSString stringWithFormat:@"%ld/%ld",(long)nowMonth +1,nowDay + i - nowMonthDay];
                [dayarray addObject:str];
            }else{
                NSString * str = [NSString stringWithFormat:@"%ld/%ld",(long)nowMonth +1 - 12,nowDay + i - nowMonthDay];
                [dayarray addObject:str];
            }
        }
    }
    return dayarray;
}
///12 当前时间获取后7天几月几号 比11的基础上多0 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getZero7DayWithString:(NSString *)timeStr{
    self.dateFormatter.dateFormat   = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * nowdate      = [self.dateFormatter dateFromString:timeStr];
    NSDateComponents * nowcomps     = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowdate];
    NSInteger          nowMonth     = nowcomps.month;
    NSInteger          nowDay       = nowcomps.day;
    NSInteger          nowMonthDay  = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowdate].length;
    NSMutableArray   * dayarray     = [NSMutableArray array];
    for (NSInteger i=0;i<nowMonthDay;i++){//31
        if (nowDay + i <= nowMonthDay){
            NSString * str = @"";
            if (nowDay+i<10 && nowMonth<10) {//天小于10 月小于10
                str = [NSString stringWithFormat:@"%.2ld/%.2ld",nowMonth,nowDay + i];
            }else if(nowDay+i<10 && nowMonth>=10){//天小于10 月大于10
                str = [NSString stringWithFormat:@"%ld/%0.2ld",nowMonth,nowDay + i];
            }else if(nowDay+i>=10 && nowMonth<10){//天大于10 月小于10
                str = [NSString stringWithFormat:@"%0.2ld/%ld",nowMonth,nowDay + i];
            }else if(nowDay+i>=10 && nowMonth>=10){//天大于10 月大于10
                str = [NSString stringWithFormat:@"%ld/%ld",nowMonth,nowDay + i];
            }
            [dayarray addObject:str];
        }else{
            if (nowMonth + 1 <= 12){
                NSString * str = @"";
                if (nowDay+i- nowMonthDay<10 && nowMonth+1<10) {
                    str = [NSString stringWithFormat:@"%.2ld/%.2ld",nowMonth + 1,nowDay + i - nowMonthDay];
                }else if(nowDay+i- nowMonthDay<10 && nowMonth+1>=10){
                    str = [NSString stringWithFormat:@"%ld/%0.2ld",nowMonth + 1,nowDay + i - nowMonthDay];
                }else if(nowDay+i- nowMonthDay>=10 && nowMonth+1<10){
                    str = [NSString stringWithFormat:@"%0.2ld/%ld",nowMonth + 1,nowDay + i - nowMonthDay];
                }else if(nowDay+i- nowMonthDay>=10 && nowMonth+1>=10){
                    str = [NSString stringWithFormat:@"%ld/%ld",nowMonth + 1,nowDay + i - nowMonthDay];
                }
                [dayarray addObject:str];
            }else{
                NSString * str = @"";
                if (nowDay + i - nowMonthDay <10 && nowMonth + 1 - 12 < 10) {
                    str = [NSString stringWithFormat:@"%.2ld/%.2ld",nowMonth + 1 - 12,nowDay + i - nowMonthDay];
                }else if(nowDay + i - nowMonthDay<10 && nowMonth+1- 12>=10){
                    str = [NSString stringWithFormat:@"%ld/%0.2ld",nowMonth + 1 - 12,nowDay + i - nowMonthDay];
                }else if(nowDay+i- nowMonthDay>=10 && nowMonth+1- 12<10){
                    str = [NSString stringWithFormat:@"%0.2ld/%ld",nowMonth + 1 - 12,nowDay + i - nowMonthDay];
                }else if(nowDay+i- nowMonthDay>=10 && nowMonth+1- 12>=10){
                    str = [NSString stringWithFormat:@"%ld/%ld",nowMonth + 1 - 12,nowDay + i - nowMonthDay];
                }
                [dayarray addObject:str];
            }
        }
    }
    return dayarray;
}
///13 今天 明天 周几 周几 周几 周几 周几 timeStr:yyyy-MM-dd HH:mm:ss
-(NSArray *)getWeekWithString:(NSString *)timeStr{
    self.dateFormatter.dateFormat   = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * nowdate      = [self.dateFormatter dateFromString:timeStr];
    NSDateComponents * nowcomps     = [self.calendar components:NSCalendarUnitWeekday fromDate:nowdate];
    NSInteger          weekDay      = [nowcomps weekday];//1-7当前周几 详细看getStringWithWeekDay方法
    NSMutableArray   * wekarray     = [NSMutableArray array];
    for (int i=0;i<7;i++){
        if (i == 0) {
            NSString * str  = @"今天";
            [wekarray addObject:str];
        }else if (i == 1) {
            NSString * str  = @"明天";
            [wekarray addObject:str];
        }else if (weekDay + i <=7){
            NSString * str  = [self getStringWithWeekDay:weekDay +i];
            [wekarray addObject:str];
        }else if (weekDay + i >=7){
            NSString * str  = [self getStringWithWeekDay:weekDay + i - 7];
            [wekarray addObject:str];
        }
    }
    return wekarray;
}
-(NSString *)getStringWithWeekDay:(NSInteger)weekDay{
    switch (weekDay) {
        case 1:{
            return  @"周日";
        }break;
        case 2:{
            return  @"周一";
        }break;
        case 3:{
            return  @"周二";
        }break;
        case 4:{
            return  @"周三";
        }break;
        case 5:{
            return  @"周四";
        } break;
        case 6:{
            return  @"周五";
        }break;
        case 7:{
            return  @"周六";
        } break;
        default:
            break;
    }
    return @"";
}
///14 目标时间与当前时间差 timeStr:yyyy-MM-dd HH:mm:ss
- (NSString *)getTimedifferenceWithString:(NSString *)timeString{
    self.dateFormatter.dateFormat     = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * passdate       = [self.dateFormatter dateFromString:timeString];
    NSTimeInterval     passtime       = [passdate timeIntervalSince1970];
    NSDate           * nowdate        = [NSDate date];
    NSTimeInterval     nowTime        = [nowdate timeIntervalSince1970];
    NSTimeInterval     timeDifference = nowTime - passtime;
    NSString         * returnString   = @"";
    if (fabs(timeDifference)<60){
        returnString =  @"刚刚发布";
    }else{
        timeDifference    = fabs(timeDifference);
        int day           = timeDifference/(3600 * 24);//天
        int hours         = (timeDifference - (day *24 *3600))/3600;//小时
        int minutes       = (timeDifference - (day *24 *3600) - hours * 3600)/60;//分钟
        if(day > 0){
            returnString  = [NSString stringWithFormat:@"%d天前发布",day];
        }else if (hours > 0){
            returnString  = [NSString stringWithFormat:@"%d小时前发布",hours];
        }else if(minutes > 0){
            returnString  = [NSString stringWithFormat:@"%d分钟前发布",minutes];
        }
    }
    return returnString;
}
///15 昨天晚上8点 今天早上8点
-(NSString *)getTodayOrYesterdayTime{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate   * nowdate            = [NSDate date];
    NSString * str                = [self.dateFormatter stringFromDate:nowdate];
    int h                         = [str substringWithRange:NSMakeRange(11, 2)].intValue;
    NSString * returnString       = @"";
    NSDateFormatter * matter      = [NSDateFormatter new];
    matter.dateFormat             = @"yyyy-MM-dd";
    if (h<8) {//昨天晚上8点
        NSTimeInterval  nowTime  = [nowdate timeIntervalSince1970];
        NSTimeInterval  passTime = nowTime - 24 * 3600;
        NSDate        * date     = [NSDate dateWithTimeIntervalSince1970:passTime];
        returnString             = [NSString stringWithFormat:@"%@ 20:00:00",[matter stringFromDate:date]];
    }else{//今天早上8点
        returnString             = [NSString stringWithFormat:@"%@ 08:00:00",[matter stringFromDate:nowdate]];
    }
    return returnString;
}
///16 传入的时间和时间格式获取 formatter 目标格式 timeStr:yyyy-MM-dd HH:mm:ss
-(NSString *)getStringWithFormatter:(NSString *)formatter andTimeString:(NSString *)timeStr{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date                 = [self.dateFormatter dateFromString:timeStr];
    self.dateFormatter.dateFormat = formatter;
    return [self.dateFormatter stringFromDate:date];
}
///17 时间戳获取时间 second 时间戳 IsSecond YES表示秒 NO 表示毫秒
-(NSString * )getNowDateWithSecond:(long long)second andIsSecond:(BOOL)isSecond{
     self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     NSDate     * date             = [NSDate dateWithTimeIntervalSince1970:isSecond ? second : second/1000];
     return [self.dateFormatter stringFromDate:date];
}
///18 获取上旬 中旬 下旬
-(NSString * )getTenDay{
    self.dateFormatter.dateFormat = @"dd";
    NSString * day                = [self.dateFormatter stringFromDate:[NSDate date]];
    if (day.integerValue <= 10) {
        return @"1";
    }else if (day.integerValue > 10 && day.integerValue <= 20){
        return @"2";
    }else{
        return @"3";
    }
}
///19时间比较
-(BOOL)getValidWithform:(NSString *)ftimeStr andValid:(double)hour andTo:(NSString *)ttimeStr{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat        = @"yyyy-MM-dd HH:mm:ss";
    NSDate          * date1     = [formatter dateFromString:ftimeStr];
    NSDate          * date2     = [formatter dateFromString:ttimeStr];
    double            time1     = [date1 timeIntervalSince1970] + hour * 3600;
    double            time2     = [date2 timeIntervalSince1970];
    return  time1>time2?YES:NO;
}














//17 yyyy年M月d日|昨天|星期日/星期一/星期二/星期三/星期四/星期五/星期六  凌晨/早上/中午/下午/晚上 小时:分钟
// timeStr:yyyy-MM-dd HH:mm:ss
- (NSString *)getStringWithAlgorithmTwo:(NSString *)timeString{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * myDate     = [self.dateFormatter dateFromString:timeString];
    NSDateComponents * nowCmps    = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents * myCmps     = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|kCFCalendarUnitHour fromDate:myDate];
    NSDateFormatter  * dateFmt    = [[NSDateFormatter alloc]init];
    if(myCmps.hour >= 0 && myCmps.hour < 6){
        dateFmt.AMSymbol = @"凌晨";
    }else if (myCmps.hour >= 6 && myCmps.hour < 12){
        dateFmt.AMSymbol = @"早上";
    } else if (myCmps.hour == 12) {
        dateFmt.AMSymbol = @"中午";
    } else if (myCmps.hour > 12 && myCmps.hour < 18) {
        dateFmt.PMSymbol = @"下午";
    } else if (myCmps.hour >= 18) {
        dateFmt.PMSymbol = @"晚上";
    }
    if (nowCmps.year != myCmps.year){
        dateFmt.dateFormat = @"yyyy年M月d日 aaahh:mm";
    } else {
        if (nowCmps.day==myCmps.day){//今天
            dateFmt.dateFormat = @"aaahh:mm";
        } else if((nowCmps.day-myCmps.day)==1){//昨天
            dateFmt.dateFormat = @"昨天 aaahh:mm";
        } else {
            if ((nowCmps.day-myCmps.day) <=7){
                switch (myCmps.weekday) {
                    case 1:{
                        dateFmt.dateFormat  = @"星期日 aaahh:mm";
                    }break;
                    case 2:{
                        dateFmt.dateFormat  = @"星期一 aaahh:mm";
                    }break;
                    case 3:{
                        dateFmt.dateFormat  = @"星期二 aaahh:mm";
                    }break;
                    case 4:{
                        dateFmt.dateFormat  = @"星期三 aaahh:mm";
                    }break;
                    case 5:{
                        dateFmt.dateFormat  = @"星期四 aaahh:mm";
                    } break;
                    case 6:{
                        dateFmt.dateFormat  = @"星期五 aaahh:mm";
                    }break;
                    case 7:{
                        dateFmt.dateFormat  = @"星期六 aaahh:mm";
                    } break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"yyyy年M月d日 aaahh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
//18 yyyy年M月d日|昨天|星期日/星期一/星期二/星期三/星期四/星期五/星期六
// timeStr:yyyy-MM-dd HH:mm:ss
- (NSString *)getStringWithAlgorithmThree:(NSString *)timeString{
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate           * myDate     = [self.dateFormatter dateFromString:timeString];
    NSDateComponents * nowCmps    = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents * myCmps     = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|kCFCalendarUnitHour fromDate:myDate];
    NSDateFormatter  * dateFmt    = [[NSDateFormatter alloc]init];
    if (nowCmps.year != myCmps.year){
        dateFmt.dateFormat = @"yyyy-MM-dd";
    } else {
        if (nowCmps.day==myCmps.day){//今天
            dateFmt.dateFormat = @"HH:mm";
        } else if((nowCmps.day-myCmps.day)==1){//昨天
            dateFmt.dateFormat = @"昨天";
        } else {
            if ((nowCmps.day-myCmps.day) <=7){
                switch (myCmps.weekday) {
                    case 1:{
                        dateFmt.dateFormat  = @"星期日";
                    }break;
                    case 2:{
                        dateFmt.dateFormat  = @"星期一";
                    }break;
                    case 3:{
                        dateFmt.dateFormat  = @"星期二";
                    }break;
                    case 4:{
                        dateFmt.dateFormat  = @"星期三";
                    }break;
                    case 5:{
                        dateFmt.dateFormat  = @"星期四";
                    } break;
                    case 6:{
                        dateFmt.dateFormat  = @"星期五";
                    }break;
                    case 7:{
                        dateFmt.dateFormat  = @"星期六";
                    } break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"yyyy-MM-dd";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
-(void)fff{
//    NSDate *date1=[NSDate date];
//    NSDate *date2=[NSDate dateWithTimeIntervalSinceNow:100];
//    NSTimeInterval time=[date2 timeIntervalSinceDate:date1];//日期之差,返回单位为秒
//    [NSValue valueWithCGRect:<#(CGRect)#>]
}
@end
