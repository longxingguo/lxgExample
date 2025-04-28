//
//  ViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/10.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "ViewController.h"
#import "YYFPSLabel.h"
#import <PassKit/PassKit.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView * demoTableView;
@property (nonatomic ,strong)NSArray     * demoArray;
@property (nonatomic ,strong)UIButton    * button;
@property (nonatomic ,strong)UIView      * payView;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.demoTableView];
    //YYFPSLabel * fps = [[YYFPSLabel alloc]initWithFrame:CGRectMake(10, 200, 100, 20)];
    //[[UIApplication sharedApplication].keyWindow addSubview:fps];
}
-(void)buttonCLick{
    //1 判断当前设备是否支持苹果支付
    if (![PKPaymentAuthorizationViewController canMakePayments]){
        NSLog(@"当前设备不支持appleapy");
        return;
    }
    //2 判断当前是否添加了银行卡
    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa]]){
        //创建添加按钮
        PKPaymentButton * addButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
        [addButton addTarget:self action:@selector(addButtonCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.payView addSubview:addButton];
    }else{
        //创建购买按钮
        PKPaymentButton * buyButton = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        [buyButton addTarget:self action:@selector(buyButtonCLick) forControlEvents:UIControlEventTouchUpInside];
        [self.payView addSubview:buyButton];
    }
}
//添加
-(void)addButtonCLick{
    PKPassLibrary * pl = [[PKPassLibrary alloc]init];
    [pl openPaymentSetup];
}
//购买
-(void)buyButtonCLick{
    //1 请求
    PKPaymentRequest * request   = [[PKPaymentRequest alloc]init];
    request.merchantIdentifier   = @"商家id";//
    request.countryCode          = @"CN";//国家代码
    request.currencyCode         = @"CNY";//货币代码
    request.supportedNetworks    = @[PKPaymentNetworkChinaUnionPay,PKPaymentNetworkVisa];//支持卡类型
    request.merchantCapabilities = PKMerchantCapability3DS;//处理方式
    NSDecimalNumber * price      = [NSDecimalNumber decimalNumberWithString:@"10.0"];//商品价格
    PKPaymentSummaryItem * item  = [PKPaymentSummaryItem summaryItemWithLabel:@"商品名称" amount:price];//商品类型
    request.paymentSummaryItems  = @[item];//商品列表
    
    request.requiredBillingAddressFields  = PKAddressFieldAll;//发票收货地址
    request.requiredShippingAddressFields = PKAddressFieldAll;//快递地址
    
    request.shippingMethods      = @[];
    //2 验证授权
    PKPaymentAuthorizationViewController * avc = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    [self presentViewController:avc animated:YES completion:^{
        
    }];
}
#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.demoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell  * cell   = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dic        = self.demoArray[indexPath.row];
    cell.textLabel.text       = [NSString stringWithFormat:@"%@-%@",dic[@"c"],dic[@"t"]];
    cell.textLabel.textColor  = [UIColor blackColor];
    cell.textLabel.font       = [UIFont systemFontOfSize:15];
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic        = self.demoArray[indexPath.row];
    [self.navigationController pushViewController:[[NSClassFromString(dic[@"c"]) alloc] init] animated:NO];
}
-(UITableView *)demoTableView{
    if(!_demoTableView){
        _demoTableView                 = [[UITableView alloc]initWithFrame:CGRectMake(0, LStatusBarHeight +44, LScreenWidth, LScreenHeight - LStatusBarHeight - 44) style:UITableViewStyleGrouped];
        _demoTableView.delegate        = self;
        _demoTableView.dataSource      = self;
        _demoTableView.tableHeaderView = [UIView new];
        [_demoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
        if (@available(iOS 11.0, *)){
            _demoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets     = NO;
        }
    }
    return _demoTableView;
}
-(NSArray *)demoArray{
    if(!_demoArray){
        _demoArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DemoController" ofType:@"plist"]];;
    }
    return _demoArray;
}
@end
