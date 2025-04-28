//
//  AppDelegate.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LXGEnvironmentWindow.h"
#import "KeychainItemWrapper.h"
#import "BaseNavigationController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    setBaseURL();
    NSLog(@"+++1，启动程序，didFinishLaunchingWithOptions");
    NSLog(@"BaseURLString%@ --- H5BaseURLString%@",BaseURLString,H5BaseURLString);
#if DEBUG
    self.window                    = [[LXGEnvironmentWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#else
    self.window                    = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#endif
    self.window.backgroundColor    = [UIColor whiteColor];
    self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[ViewController alloc]init]];
    [self.window makeKeyAndVisible];
    
    //[self checkDic];
   // [self checkUUID];
//    [self checkFont];
//    [self GHPocmp];
//    [self getjson];
    return YES;
}
//乱七八糟
-(void)lqbz{
    NSString     * test     = @"哈哈";
    NSDictionary * testdic  = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect         rect     = [test boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:testdic context:nil];
    NSLog(@"%@",NSStringFromCGSize(rect.size));
    
    //    NSString * str = @"管理员回复测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论测试管理员评论";
        //NSLog(@"%f",[str boundingRectWithSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height);
        //NSStringDrawingUsesLineFragmentOrigin
        //NSStringDrawingUsesFontLeading:根据字体计算高度
        
    //    NSString * str1 = [str substringToIndex:5];
    //    NSString * str2 = [str substringFromIndex:5];
    //    NSLog(@"%@  %@",str1,str2);
    
    
    
    
    NSLog(@"%f",  ceil(10 / 3));  //结果是3
    NSLog(@"%f",  ceil(10 / 3.0));  //结果是4
    /*int abs(int i); // 处理int类型的取绝对值
    double fabs(double i); //处理double类型的取绝对值
    float fabsf(float i); /处理float类型的取绝对值
    向上取整：float ceilf(float) ;double ceil (double)返回不小于当前值得最小整数值 然后转double;
    向下取整：float floorf(float);double floor(double)返回不大于当前值得最小整数值 然后转double;
    四舍五入：float roundf(float);double round(double)返回当前值的四舍五入整数值; 然后转double;*/
    CGFloat a      = 3.3;
    CGFloat ceilA  = ceilf(a);
    CGFloat floorA = floorf(a);
    CGFloat roundA = roundf(a);
    NSLog(@"%lf 向上取整为%lf, 向下取整为%lf, 四舍五入为%lf", a, ceilA, floorA, roundA);
    //3.300000 向上取整为4.000000, 向下取整为3.000000, 四舍五入为3.000000
    double b      = 5.8;
    double ceilB  = ceil(b);
    double floorB = floor(b);
    double roundB = round(b);
    NSLog(@"%lf 向上取整为%lf, 向下取整为%lf, 四舍五入为%lf", b, ceilB, floorB, roundB);
    //5.800000 向上取整为6.000000, 向下取整为5.000000, 四舍五入为6.000000
    CGFloat c      = -3.3;
    CGFloat ceilC  = ceilf(c);
    CGFloat floorC = floorf(c);
    CGFloat roundC = roundf(c);
    NSLog(@"%lf 向上取整为%lf, 向下取整为%lf, 四舍五入为%lf", c, ceilC, floorC, roundC);
    //-3.300000 向上取整为-3.000000, 向下取整为-4.000000, 四舍五入为-3.000000
    double d      = -5.8;
    double ceilD  = ceil(d);
    double floorD = floor(d);
    double roundD = round(d);
    NSLog(@"%lf 向上取整为%lf, 向下取整为%lf, 四舍五入为%lf", d, ceilD, floorD, roundD);
    //-5.800000 向上取整为-5.000000, 向下取整为-6.000000, 四舍五入为-6.000000
    
    
    
        //错误
    //    NSDictionary * dic = @{@"string0":@"string",
    //                           @"Integer1":@"Integer",
    //                           @"Double2":@"Double",
    //                           @"Boolean3":@"Boolean",
    //                           @"DateTime4":@"DateTime",
    //                           @"Decimal5":@"Decimal",
    //                           @"Int326":@"Int32",
    //                           @"string7":@"s7",
    //                           @"Integer8":@"8",
    //                           @"string9":@"s9",
    //                           @"Integer10":@"s10",
    //                           @"Int3211":@"s11"};
    //    NSArray * array  = dic.allKeys;
    //    NSLog(@"%@",array);
    //    for (NSString *str in array) {
    //        if ([array indexOfObject:str] < 10) {
    //            NSString * mustr  = [str substringFromIndex:str.length -1];
    //            NSInteger  index  = [mustr integerValue];;
    //            NSLog(@"%@ - %ld",mustr,(long)index);
    //        }else{
    //            NSString * mustr  = [str substringFromIndex:str.length -2];
    //            NSInteger  index  = [mustr integerValue];;
    //            NSLog(@"%@ - %ld",mustr,(long)index);
    //        }
    //    }
        //正常
        NSDictionary * dic = @{@"string-0":@"string",
                               @"Integer-1":@"Integer",
                               @"Double-2":@"Double",
                               @"Boolean-3":@"Boolean",
                               @"DateTime-4":@"DateTime",
                               @"Decimal-5":@"Decimal",
                               @"Int32-6":@"Int32",
                               @"string-7":@"s7",
                               @"Integer-8":@"8",
                               @"string-9":@"s9",
                               @"Integer-10":@"s10",
                               @"Int32-11":@"s11"};
        NSArray * array  = dic.allKeys;
        NSLog(@"%@",array);
        for (NSString *str in array) {
            NSInteger  index  = 0;
            NSString * mustr  = [str substringFromIndex:str.length - 2];
            mustr             = [mustr integerValue] >= 10 ? mustr: [str substringFromIndex:str.length -1];
            index             = [mustr integerValue];
            NSLog(@"%@ - %ld - %@",mustr,(long)index,dic[str]);
        }
}
//测大小
-(void)checkFont{
    //字体
    UIFont * font   = [UIFont systemFontOfSize:12];
    NSLog(@"font.pointSize = %f,font.ascender = %f,font.descender = %f,font.capHeight = %f,font.xHeight = %f,font.lineHeight = %f,font.leading = %f",font.pointSize,font.ascender,font.descender,font.capHeight,font.xHeight,font.lineHeight,font.leading);
    //视图
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 0, 0)];
    lable.text      = @"计";//
    lable.font      = font;
    [lable sizeToFit];
   // CGSize sizeThatFits = [lable sizeThatFits:CGSizeZero];
    NSLog(@"sizeToFit-%@",NSStringFromCGRect(lable.frame));
//    sizeToFit:会计算出最优的 size 而且会改变自己的size
//    sizeThatFits:会计算出最优的 size 但是不会改变 自己的 size
    
}
//唯一标识符
-(void)checkUUID{
    KeychainItemWrapper * wrapper    = [[KeychainItemWrapper alloc] initWithIdentifier:@"fujianhuawang" accessGroup:nil];
    NSString            * UUIDString = [wrapper objectForKey:(__bridge id)kSecValueData];
    if (UUIDString.length == 0) {
        UUIDString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [wrapper setObject:UUIDString forKey:(__bridge id)kSecValueData];
    }
    NSLog(@"%@", UUIDString);
}
/*
 // 下面两行代码用来标识一个Item
 KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"标识" accessGroup:nil];
 [keyWrapper setObject:@"myChainValues" forKey:(id)kSecAttrService];
 // 保存账号和密码信息
 [keyWrapper setObject:[usernameTextField text] forKey:(id)kSecAttrAccount];
 [keyWrapper setObject:[passwordTextField text] forKey:(id)kSecValueData];
 // 读取账号和密码信息
 // [usernameTextField setText:[keyWrapper  objectForKey:(id)kSecAttrAccount]];
 // [passwordTextField setText:[keyWrapper objectForKey:(id)kSecValueData]];
 */
//去重
-(void)checkDic{
    NSDictionary        * dic1    = @{@"1":@"11",@"2":@"22",@"3":@"33"};
    NSDictionary        * dic2    = @{@"1":@"11",@"2":@"22",@"3":@"44"};
    NSMutableDictionary * mdic    = [NSMutableDictionary dictionary];
    NSArray             * mArray1 = dic1.allKeys;
    NSArray             * mArray2 = dic2.allKeys;
    for (NSString * key in mArray1) {
        mdic[key] = dic1[key];
    }
    for (NSString * key in mArray2) {
        mdic[key] = dic2[key];
    }
    NSLog(@"%@",mdic);
}
//排序
-(void)GHPocmp{
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray: @[@"8",@"2",@"5",@"3",@"6",@"4"]];
    for (int j = 1; j < array.count; j++) {
        //array.count-j j从1开始 是为了防止数组越界
        //循环一次把最大的一个数排在最后面
        //下次循环的时候就把最后那个数给忽略了,不比较他了,因为他比前面的数字都大;所以每次都-j
        
        //再粗俗点说就是
        //第一次循环把最大的数放到了最后 8
        //跌二次循环把倒数第二大的数放到了倒数第二位 6,8
        //      5,6,8
        //    4,5,6,8
        //  3,4,5,6,8
        //2,3,4,5,6,8
        for (int i = 0; i < array.count-j; i++) {
            if ([array[i] integerValue]>[array[i+1] integerValue]) {
                [array exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                //冒泡排序由小到大排序
                //1.循环比较第i个和i+1个大小,如果i>i+1则交换它俩的位置
                //一次循环下来把最大的数字排到了最后面
                //比如说这几个数字
                //@"8",@"2",@"5",@"3",@"6",@"4"
                /** 第一次循环 i=0; i<array.count-1;
                 结果是 2,5,3,6,4,8
                 */
                /** 第二次循环 i=0; i<array.count-2;
                 因为-2 这里相当于只对2,5,3,6,4进行排序 8忽略不比较;
                 结果是 2,3,5,4,6,8
                 */
                /** 第三次循环 i=0; i<array.count-3;
                 因为-2 这里相当于只对2,3,5,4进行排序 6,8忽略不比较;
                 结果是 2,3,4,5,6,8
                 */
            }
        }
        NSLog(@"第%d次排序结果:%@",j,array);
    }
}
-(void)getjson{
        NSDictionary * onedic   = [self getJsonWithResource:@"citycode" andType:@"json" andIsCode:NO];
        NSDictionary * twodic   = onedic[@"DATAPACKET"];
        NSArray * nameArray     = twodic[@"STATION"];
        NSMutableArray * new    = [NSMutableArray array];
        for (NSDictionary * threedic in nameArray){
            NSArray * cityarr   = threedic[@"STATION"];
            for (NSDictionary * fourdic in cityarr){
                NSMutableArray * marr        = [NSMutableArray array];
                //市code
                NSMutableDictionary * mdic1  = [NSMutableDictionary dictionary];
                mdic1[@"areacode"]           = fourdic[@"areacode"];
                mdic1[@"code"]               = fourdic[@"code"];
                [marr addObject:mdic1];
                //区县code
                NSArray * areaarr            = fourdic[@"STATION"];
                for (NSDictionary * fivedic in areaarr){
                    NSMutableDictionary * mdic2  = [NSMutableDictionary dictionary];
                    mdic2[@"areacode"]           = fivedic[@"areacode"];
                    mdic2[@"code"]               = fivedic[@"code"];
                    [marr addObject:mdic2];
                }
                [new addObjectsFromArray:marr];
            }
        }
        NSLog(@"%@",new);
        //这个是苹果格式
    //    BOOL res = [new writeToFile:@"/Users/longxingguo/Desktop/tourismInfo.json" atomically:YES];
    //    if(res){
    //        NSLog(@"成功");
    //    }
    NSMutableArray * resarray = [NSMutableArray array];
    for (NSDictionary * rdic in new) {
        NSMutableDictionary * resdic = [NSMutableDictionary dictionary];
        resdic[@"areacode"]          = rdic[@"areacode"];
        resdic[@"code"]              = rdic[@"code"];
        resdic[@"cname"]             = [LXGStringTool firstCharactor:rdic[@"areacode"]];
        [resarray addObject:resdic];
    }
    NSLog(@"%@",resarray);
    //按拼音排序
    NSArray * tempDatas = [resarray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            return [obj1[@"cname"] compare:obj2[@"cname"]];
    }];
    //分离拼音
    NSMutableArray * pinyinArray = [NSMutableArray array];
    for (NSDictionary * fdic in tempDatas){
        if (![pinyinArray containsObject:fdic[@"cname"]]) {
            [pinyinArray addObject:fdic[@"cname"]];
        }
    }
    //按拼音分组
    NSMutableArray * pacArray = [NSMutableArray array];
    for (NSString * pinyin in pinyinArray) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"cname = %@",pinyin];
        NSArray     * resultArr = [tempDatas filteredArrayUsingPredicate:predicate];
        NSMutableDictionary * mdic3 = [NSMutableDictionary dictionary];
        mdic3[@"groupname"]    = pinyin;
        mdic3[@"stationlist"]  = resultArr;
        [pacArray addObject:mdic3];
    }
    NSLog(@"%@",pacArray);
    
//        // 这个是json格式 首先初始化一下数据流， path 是本地沙盒中的一个路径
    NSOutputStream * outStream = [[NSOutputStream alloc] initToFileAtPath:@"/Users/longxingguo/Desktop/citycode.json" append:NO];
////      // 打开数据流
    [outStream open];
////      // 执行写入方法，并接收写入的数据量
    NSInteger length = [NSJSONSerialization writeJSONObject:pacArray toStream:outStream options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@"write %ld bytes",(long)length);
////       // 关闭数据流， 写入完成
    [outStream close];
    
}
//读取json
-(id)getJsonWithResource:(NSString *)resource andType:(NSString *)type andIsCode:(BOOL)isCode{
    NSString     * path     = [[NSBundle mainBundle]pathForResource:resource ofType:type];
    NSData       * jsonData = [[NSData alloc] initWithContentsOfFile:path];
    if (isCode){
        NSString * strdata  = [[NSString alloc]initWithData:jsonData encoding:kCFStringEncodingUTF8];
        jsonData            = [strdata dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSError      * error;
    id json                 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return json;
}


//新安装一个程序并启动
//+++1启动程序
//+++5变为活跃状态
//点击一次home键
//+++2将变为非活跃状态
//+++3进入后台
//承接以上复原程序
//+++4由后台进入前台
//+++5变为活跃状态
//直接锁屏
//+++2将变为非活跃状态 质疑有时候没有执行2
//+++3进入后台
//承接以上开启锁屏
//+++4由后台进入前台
//+++5变为活跃状态
//点击两次home键
//+++2将变为非活跃状态
//点击两次home键后 杀死操作 杀死程序
//+++3进入后台
//+++6程序被杀死
//有电话进入
//+++2将变为非活跃状态
//电话挂断
//+++5变为活跃状态
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"+++2，将变为非活跃状态，applicationWillResignActive");
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"+++3，进入后台，applicationDidEnterBackground");
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"+++4，由后台进入前台，applicationWillEnterForeground");
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"+++5，变为活跃状态，applicationDidBecomeActive");
}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"+++6，程序被杀死，applicationWillTerminate");
}
@end
