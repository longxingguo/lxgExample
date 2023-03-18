//
//  LXGChartsViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/19.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGChartsViewController.h"
#import <Charts/Charts-Swift.h>
#import "Notes-Swift.h"
@interface LXGChartsViewController ()<ChartViewDelegate,YHBarChartRendererDelegate>
//@property (nonatomic ,strong)PieChartView  * pchartView;
@property (nonatomic ,strong)BarChartView  * bchartView;
@property (nonatomic ,strong)LineChartView * lineChartView;
//@property (nonatomic ,strong)NSArray       * sarray;

@property (nonatomic ,assign)NSInteger selectindex;
@end
@implementation LXGChartsViewController
-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    NSLog(@"chartValueSelected");
    NSLog(@"---chartValueSelected---value: x = %g,y = %g",entry.x,  entry.y);
    NSLog(@"---chartValueSelected---value:第 %@ 个数据", entry.data);
   // [self.lineChartView highlightValues:self.sarray];
}
//图标中的空白区域被点击
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    //[self.lineChartView highlightValues:self.sarray];
}
//图表缩放
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
}
//图标被移动
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
}
//需求一:两个表格联动，即拖拽或者一个，另一个需要跟着动。
//这个需求可以用协议解决:
//- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
//    CGAffineTransform srcMatrix = chartView.viewPortHandler.touchMatrix;
//    [self.lineChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.combinedChartView invalidate:YES];
//    [self.barChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.barChartView invalidate:YES];
//}
//- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
//    CGAffineTransform srcMatrix = chartView.viewPortHandler.touchMatrix;
//    [self.lineChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.combinedChartView invalidate:YES];
//    [self.barChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.barChartView invalidate:YES];
//}
//需求二：在一个图表上绘制多种类型的线表，例如K线图+柱状图
//这个需求会用到另一个ChartView类型:CombinedChartView
//CombinedChartData *combinedData = [[CombinedChartData alloc] init];
//combinedData.lineData = [self generateLineData];
//combinedData.candleData = [self generateCandleData];
//需求三：希望在X轴上显示出具体的数值
//我刚才说过，绘制表格的时候X值是i的值，即从0到i，那么我们如何显示服务器给我们的X值呢？这里需要引入一个协议:IChartAxisValueFormatter,声明一个NSObject类，如BTCDepthXAxisFormatter遵循IChartAxisValueFormatter协议，重写-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis方法，然后进行赋值，xAxis.valueFormatter = [[BTCDepthXAxisFormatter alloc] init]即可。
-(void)viewDidLoad{
    [super viewDidLoad];
   // [self bing];
//    [self zhu];
    [self xian];
}
// 递归获取子视图
-(void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];

    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;

    for (UIView *subview in subviews) {

        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }

        // 打印子视图类名
        NSLog(@"%@%d: %@", blank, level, subview.class);

        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];

    }
}
//线
-(void)xian{
    self.lineChartView          = [[LineChartView alloc] init];
    self.lineChartView.delegate = self;
    [self.view addSubview:self.lineChartView];
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.lineChartView.mas_width);
    }];
    if ([self.lineChartView isKindOfClass:[UIScrollView class]]) {
        NSLog(@"我是ScrollView");
    }
    //无数据
    self.lineChartView.noDataText          = @"暂无数据";//无数据显示
    self.lineChartView.noDataTextColor     = LColor(@"0x21B7EF");//颜色
    self.lineChartView.noDataFont          = [UIFont fontWithName:@"PingFangSC" size:15];//字体
    self.lineChartView.noDataTextAlignment = NSTextAlignmentCenter;//对齐
    //交互
    self.lineChartView.drawGridBackgroundEnabled    = NO;//不网格
    self.lineChartView.drawBordersEnabled           = NO;//不边框
    self.lineChartView.highlightPerTapEnabled       = NO;//不高亮
    self.lineChartView.legend.enabled               = NO;//不图例
    self.lineChartView.scaleYEnabled                = NO;//取消Y轴缩放
    self.lineChartView.scaleXEnabled                = NO;//取消X轴缩放
    self.lineChartView.doubleTapToZoomEnabled       = NO;//取消双击缩放
    self.lineChartView.dragEnabled                  = YES;//启用拖拽
    self.lineChartView.dragDecelerationEnabled      = YES;//拖拽后是否有惯性效果
    self.lineChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //X轴
    ChartXAxis * xAxis                              = self.lineChartView.xAxis;
    xAxis.axisLineWidth                             = 1.0;//设置X轴线宽
    xAxis.labelPosition                             = XAxisLabelPositionBottom;//X轴的显示位置
    xAxis.drawGridLinesEnabled                      = NO;//不绘制网格线
    xAxis.labelTextColor                            = LColor(@"#057748");//label文字颜色
    xAxis.labelFont                                 = [UIFont systemFontOfSize:10];
    xAxis.granularity                               = 1;//避免显示过少的坐标值 当两个相邻的值四舍五入后相同的话，坐标值会重复
    //xAxis.axisMinValue                            = -0.3;     // label间距
    //左Y轴
    ChartYAxis * leftAxis                           = self.lineChartView.leftAxis;
    leftAxis.labelTextColor                         = LColor(@"#057748");//文字颜色
    leftAxis.labelFont                              = [UIFont systemFontOfSize:10.0f];//文字字体
    leftAxis.gridLineDashLengths                    = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor                              = [UIColor greenColor];//网格线颜色
    leftAxis.axisLineWidth                          = 1.0;//Y轴线宽
    leftAxis.axisLineColor                          = [UIColor clearColor];//Y轴颜色
    leftAxis.gridAntialiasEnabled                   = YES;//开启抗锯齿
    leftAxis.labelCount                             = 4;
    NSNumberFormatter * numberFormatter             = [[NSNumberFormatter alloc]init];
    numberFormatter.numberStyle                     = NSNumberFormatterDecimalStyle;//小数点形式
    numberFormatter.maximumFractionDigits           = 2;//小数位最多位数
    numberFormatter.positiveSuffix                  = @"m";//正数的后缀
    leftAxis.valueFormatter                         = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numberFormatter];
    leftAxis.labelPosition                          = YAxisLabelPositionOutsideChart;//label位置 轴内或者是轴外
    leftAxis.axisMaximum                            = 370.95;//必须给值吗??
    leftAxis.spaceBottom                            = 0.1;//y轴顶部距图形底部部距离占总长的百分比（对应的还有顶部）
    
    //x轴数据
    NSMutableArray * carray                         = [NSMutableArray array];
    int    xVals_count                              = 12;
    NSMutableArray * xVals                          = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        if(i>3){
            [carray addObject:[UIColor redColor]];
        }else{
            [carray addObject:[UIColor greenColor]];
        }
        [xVals addObject:[NSString stringWithFormat:@"%d月", i+1]];
    }
    xAxis.labelCount                                = xVals_count;
    xAxis.valueFormatter                            = [[ChartIndexAxisValueFormatter alloc] initWithValues:xVals];
    
    //x轴自定义
    LXGXAxisRenderer * xAxisRenderer                = [[LXGXAxisRenderer alloc]initWithViewPortHandler:self.lineChartView.viewPortHandler xAxis:self.lineChartView.xAxis transformer:[self.lineChartView getTransformerForAxis:leftAxis.axisDependency]];
//    xAxisRenderer.drawImagesEnabled                 = YES;
    xAxisRenderer.images                            = @[@"RealTime_rose",@"WaterPrediction_rose",@"RealTime_rose",@"WaterPrediction_rose",@"RealTime_rose",@"RealTime_rose",@"RealTime_rose",@"WaterPrediction_rose",@"WaterPrediction_rose",@"RealTime_rose",@"RealTime_rose",@"RealTime_rose"];
    xAxisRenderer.drawLablesEnabled                 = YES;
    xAxisRenderer.labelTextColors                   = carray;
    self.lineChartView.xAxisRenderer                = xAxisRenderer;
    
    
    
    //极限值
    ChartLimitLine * limitLine                      = [[ChartLimitLine alloc] initWithLimit:365 label:@"限制线"];
    limitLine.lineWidth                             = 2;
    limitLine.lineColor                             = [UIColor greenColor];
    limitLine.lineDashLengths                       = @[@5.0f, @5.0f];
    limitLine.labelPosition                         = ChartLimitLabelPositionTopRight;
    limitLine.valueTextColor                        = LColor(@"#057748");
    limitLine.valueFont                             = [UIFont systemFontOfSize:12];
    leftAxis.drawLimitLinesBehindDataEnabled        = YES;
    [leftAxis addLimitLine:limitLine];
    //右Y轴
    //self.lineChartView.rightAxis.enabled            = NO;//不绘制右边轴
    ChartYAxis * rightAxis                          = self.lineChartView.rightAxis;
    rightAxis.labelTextColor                         = LColor(@"#057748");
    rightAxis.labelFont                              = [UIFont systemFontOfSize:10.0f];
    rightAxis.axisLineColor                          = [UIColor clearColor];
    rightAxis.drawGridLinesEnabled                   = NO;
    rightAxis.labelCount                             = 4;
    NSNumberFormatter * numberFormatter1             = [[NSNumberFormatter alloc]init];
    numberFormatter1.numberStyle                     = NSNumberFormatterDecimalStyle;//小数点形式
    numberFormatter1.maximumFractionDigits           = 1;//小数位最多位数
    numberFormatter1.positiveSuffix                  = @"m";//正数的后缀
    rightAxis.valueFormatter                         = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numberFormatter1];
    rightAxis.labelPosition                          = YAxisLabelPositionOutsideChart;//label位置 轴内或者是轴外
    rightAxis.axisMaximum                            = 7.29;
    rightAxis.spaceBottom                            = 0.8;
    

    //左边y轴数据
    NSMutableArray * yVals     = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++){
        double val             = 360.95;//3611.11 + 0.1*i;
        ChartDataEntry * entry = [[ChartDataEntry alloc] initWithX:i y:val data:@"升"];
//      ChartDataEntry * entry = [[ChartDataEntry alloc] initWithX:i y:val icon:[UIImage imageNamed:@"Weather_heat"]];
        [yVals addObject:entry];
    }
    LineChartDataSet * set1          = [[LineChartDataSet alloc] initWithEntries:yVals label:@""];
    set1.mode                        = LineChartModeLinear;//线条
    set1.colors                      = carray;
    set1.drawIconsEnabled            = NO;//是否绘制图标
    set1.lineWidth                   = 1.0;//折线宽度
//    set1.color                       = [UIColor blackColor];//颜色
    set1.drawCirclesEnabled          = NO;//是否绘制拐点
    set1.circleColors                = @[[UIColor redColor], [UIColor greenColor]];//拐点颜色
    set1.circleRadius                = 5.0f;//拐点半径
    set1.drawCircleHoleEnabled       = YES;//是否画空心圆 是否绘制中间的空心
    set1.circleHoleRadius            = 2.0f;//空心的半径
    set1.circleHoleColor             = [UIColor blackColor];//空心的颜色
    set1.valueColors                 = @[[UIColor redColor]];//折线拐点处显示数据的颜色
    set1.drawValuesEnabled           = NO;//是否在拐点处显示数据
    set1.highlightEnabled            = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set1.highlightColor              = [UIColor clearColor];//点击选中拐点的十字线的颜色
    set1.highlightLineWidth          = 1.0;//十字线宽度
    set1.highlightLineDashLengths    = @[@5, @5];
    set1.axisDependency              = AxisDependencyLeft;
    set1.drawFilledEnabled           = YES;//是否填充颜色
    NSArray *gradientColors          = @[(id)LColor(@"FFFFFFFF").CGColor,(id)LColor(@"FF007FFF").CGColor];
    CGGradientRef gradientRef        = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    set1.fill                        = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//渐变填充
    //set1.fillColor = [UIColor redColor];//单色填充
    set1.fillAlpha                   = 0.3f;//透明度
    CGGradientRelease(gradientRef);
    //右y轴数据
    NSMutableArray * yVals2          = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        double val = 6.29;//7.11;
        ChartDataEntry * entry = [[ChartDataEntry alloc] initWithX:i y:val];
        [yVals2 addObject:entry];
    }
    LineChartDataSet * set2           = [[LineChartDataSet alloc] initWithEntries:yVals2 label:@""];
    set2.color                        = [UIColor yellowColor];
    set2.axisDependency              = AxisDependencyRight;
    NSMutableArray * dataSets        = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    
    
    //y轴自定义
    LXGYAxisRenderer * leftyAxisRenderer                = [[LXGYAxisRenderer alloc]initWithViewPortHandler:self.lineChartView.viewPortHandler yAxis:self.lineChartView.leftAxis transformer:[self.lineChartView getTransformerForAxis:leftAxis.axisDependency]];
    leftyAxisRenderer.drawImagesEnabled                 = YES;
    leftyAxisRenderer.images                            = @[@"RealTime_rose",@"WaterPrediction_rose",@"RealTime_rose",@"WaterPrediction_rose",@"RealTime_rose",@"RealTime_rose",@"RealTime_rose",@"WaterPrediction_rose",@"WaterPrediction_rose",@"RealTime_rose",@"RealTime_rose",@"RealTime_rose"];
    self.lineChartView.leftYAxisRenderer                = leftyAxisRenderer;
    
    
    
    LineChartData * data              = [[LineChartData alloc] initWithDataSets:dataSets];
    data.valueFont                    = [UIFont fontWithName:@"HelveticaNeue-Light" size:8.f];//文字字体
    data.valueTextColor               = [UIColor redColor];//文字颜色
    NSNumberFormatter * formatter     = [[NSNumberFormatter alloc] init];
    formatter.numberStyle             = NSNumberFormatterDecimalStyle;//小数点形式
    formatter.maximumFractionDigits   = 2;//小数位最多位数
    formatter.positiveSuffix          = @"°";//正数的后缀
    ChartDefaultValueFormatter * fter = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    data.valueFormatter               = fter;
    self.lineChartView.data           = data;
    [self.lineChartView setVisibleXRangeMaximum:5];
    //永恒气泡用
    NSMutableArray * array       = [NSMutableArray array];
    for (int i = 0; i <yVals.count; i ++) {
        ChartDataEntry * entry   = yVals[i];
        //[self.lineChartView highlightValueWithX:entry.x dataSetIndex:0 dataIndex:i callDelegate:NO];//单个无效
        //[self.lineChartView highlightValueWithX:entry.x y:entry.y dataSetIndex:0 dataIndex:i];//单个有效
        //[self.lineChartView highlightValueWithX:entry.x y:entry.y dataSetIndex:0 dataIndex:i callDelegate:NO];//单个有效
        ChartHighlight * highlight = [[ChartHighlight alloc]initWithX:entry.x y:entry.y dataSetIndex:0 dataIndex:i];
        [array addObject:highlight];
    }
    [self.lineChartView highlightValues:array];
    LXGMarkerView * mark        = [[LXGMarkerView alloc]initWithFrame:CGRectMake(-15, -25, 30, 15)];
    mark.chartView              = self.lineChartView;
    self.lineChartView.marker   = mark;
}
//柱
-(void)zhu{
    BOOL isHorizontal        = NO;           //水平   x向下 y平行                     //竖直 y向下 x平行
    self.bchartView          = isHorizontal ? [[HorizontalBarChartView alloc]init] : [[BarChartView alloc]init];
    self.bchartView.delegate = self;
    [self.view addSubview:self.bchartView];
    [self.bchartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(self.bchartView.mas_width);
    }];
    [self.bchartView setExtraOffsetsWithLeft:20 top:40 right:20 bottom:40];
    //
    self.bchartView.drawGridBackgroundEnabled = YES;//是否绘制网状格局背景(灰色那一块)
    self.bchartView.drawBarShadowEnabled      = NO; //是否绘制阴影背景
    self.bchartView.drawValueAboveBarEnabled  = YES;//数值显示在顶部上还是下  YES上
//    self.bchartView.extraBottomOffset         = 20;  //距离底部的额外偏移
//    self.bchartView.extraTopOffset            = 20;  //距离顶部的额外偏移
    self.bchartView.fitBars                   = YES;//统计图完全显示
    // X轴
    ChartXAxis * xAxis                        = self.bchartView.xAxis;
    xAxis.axisLineWidth                       = 1;//设置X轴线宽
    xAxis.axisLineColor                       = [UIColor redColor];//设置X轴线颜色
    xAxis.labelPosition                       = XAxisLabelPositionBottom;//X轴label在底部显示
    xAxis.labelFont                           = [UIFont systemFontOfSize:13];//X轴label文字大小
    xAxis.labelTextColor                      = LColor(@"0x515254");//X轴label文字颜色
    xAxis.drawGridLinesEnabled                = NO;//不绘制网格线（X轴就绘制竖线，Y轴绘制横线）
//    xAxis.labelRotationAngle = 45 //旋转角度
    //右边Y轴
    self.bchartView.rightAxis.enabled          = NO; //隐藏右边轴
    //左边Y轴
    ChartYAxis *leftAxis                      = self.bchartView.leftAxis;
    leftAxis.axisLineWidth                    = 0.5;//Y轴线宽
    leftAxis.axisLineColor                    = [UIColor redColor];//Y轴颜色
    leftAxis.labelPosition                    = YAxisLabelPositionOutsideChart;//Y轴label位置
    leftAxis.labelFont                        = [UIFont systemFontOfSize:10.0f];//Y轴文字字体
    leftAxis.labelTextColor                   = [UIColor blueColor];//Y轴文字颜色
    leftAxis.drawGridLinesEnabled             = YES;//绘制网格线（X轴就绘制竖线，Y轴绘制横线）
    leftAxis.gridLineDashLengths              = @[@3.0f, @3.0f];//设置Y轴虚线样式的网格线
    leftAxis.gridColor                        = [UIColor greenColor];//Y轴网格线颜色
    leftAxis.gridAntialiasEnabled             = YES;//开启Y轴锯齿线
    leftAxis.axisMinimum                      = 0;//Y轴最小值（不然不会从0开始）
    leftAxis.forceLabelsEnabled               = NO;//不强制绘制制定数量的label YES强制
    leftAxis.inverted                         = NO;//是否将Y轴进行上下翻转
    leftAxis.drawAxisLineEnabled              = YES;//是否画轴线
    NSNumberFormatter *numberFormatter        = [[NSNumberFormatter alloc]init];
    numberFormatter.positiveSuffix            = @" 小时";//正数时的后缀
    leftAxis.valueFormatter                   = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numberFormatter];//Y轴文字描述单位
    //极限值
    ChartLimitLine * limitLine                = [[ChartLimitLine alloc] initWithLimit:35 label:@"极限值"];
    limitLine.lineWidth                       = 2;//极限值的线宽
    limitLine.lineColor                       = [UIColor greenColor];;//极限值的颜色
    limitLine.lineDashLengths                 = @[@5.0f, @5.0f];//极限值的样式
    limitLine.labelPosition                   = ChartLimitLabelPositionTopLeft;;//极限值的位置
    leftAxis.drawLimitLinesBehindDataEnabled  = YES;//设置极限值线绘制在柱形图的后面
    [leftAxis addLimitLine:limitLine];
    //无数据
    self.bchartView.noDataTextColor            = LColor(@"0x21B7EF");//没有数据时的文字颜色
    self.bchartView.noDataFont                 = [UIFont systemFontOfSize:15]; //没有数据时的文字字体
    self.bchartView.noDataText                 = @"暂无数据";//没有数据是显示的文字说明
    //图描述
    self.bchartView.chartDescription.text      = @"工时统计图";//统计图名字
    self.bchartView.chartDescription.enabled   = YES;//是否显示统计图
    self.bchartView.chartDescription.textColor = [UIColor redColor];//统计图名字颜色
    self.bchartView.chartDescription.textAlign = NSTextAlignmentLeft;//统计图名字对齐方式
    self.bchartView.chartDescription.xOffset   = 50;//饼状图名字x轴偏移 正 左移 负 右移
    self.bchartView.chartDescription.yOffset   = - 50;//饼状图名字y轴偏移 正 上移 负 下移
    //图例
    self.bchartView.legend.enabled             = YES;
    self.bchartView.legend.maxSizePercent      = 0.1;///图例在饼状图中的大小占比, 这会影响图例的宽高
    self.bchartView.legend.formToTextSpace     = 5;//图示和文字的间隔
    self.bchartView.legend.font                = [UIFont systemFontOfSize:10];//图例字体大小
    self.bchartView.legend.textColor           = [UIColor blackColor];//图例字体颜色
    self.bchartView.legend.form                = ChartLegendFormSquare;//图示样式: 方形、线条、圆形
    self.bchartView.legend.formSize            = 5;//图示大小
    self.bchartView.legend.yOffset             = 5;
    //统计图的交互
    self.bchartView.pinchZoomEnabled             = YES;//x、y轴捏合缩放
    self.bchartView.scaleYEnabled                = YES;//Y轴缩放
    self.bchartView.doubleTapToZoomEnabled       = NO;//取消双击缩放
    self.bchartView.dragEnabled                  = YES;//启用拖拽图表
    self.bchartView.dragDecelerationEnabled      = YES;//拖拽后是否有惯性效果
    self.bchartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
//    self.bchartView.userInteractionEnabled       = NO;
    //数据
    NSArray * numbers                            = @[@"10",@"20",@"30",@"40"];
    NSArray * names                              = @[@"情况1,哈哈",@"情况2",@"情况3",@"情况4"];
    NSMutableArray *yVals                        = [[NSMutableArray alloc] init];
    for (int i = 0; i < numbers.count; i++){
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:[numbers[i] doubleValue] data:[NSString stringWithFormat:@"%d",i]]];
//        if(i ==1){
//            BarChartDataEntry * Entry = yVals[i];
//            [self.bchartView highlightValueWithX:Entry.x y:Entry.y dataSetIndex:0 dataIndex:i];//单个有效
//        }
    }
    BarChartDataSet *set                         = [[BarChartDataSet alloc] initWithEntries:yVals label:@"我是图例"];
    //set.colors                                   = @[LColor(@"0x96B5D4"),LColor(@"0xF27655"),LColor(@"0x7ECBC3"),LColor(@"0x8ACDA2")];//循环
    set.drawValuesEnabled                        = YES;//是否在柱形图上面显示数值
    set.highlightEnabled                         = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    set.highlightAlpha                           = 1;
//    set.highlightColor
//    let dataSet = BarChartDataSet(values: entries, label: nil)
//    dataSet.barGradientOrientation = .vertical
//    dataSet.barGradientColors = [[color1 color2], [color3, color4]]

    
    YHBarChartRenderer * yhRender = [[YHBarChartRenderer alloc] initWithDataProvider:self.bchartView animator:self.bchartView.renderer.animator viewPortHandler:self.bchartView.renderer.viewPortHandler];
           yhRender.delegate      = self;
    self.bchartView.renderer      = yhRender;
    
    BarChartData *data                           = [[BarChartData alloc] initWithDataSet:set];
    data.barWidth                                = 0.5;//统计图宽占X轴的比例
    NSNumberFormatter *numFormatter              = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle                     = NSNumberFormatterDecimalStyle;//小数点形式
    numFormatter.maximumFractionDigits           = 2;//小数位最多位数
    numFormatter.positiveSuffix                  = @" 小时";//正数的后缀 numFormatter.negativeSuffix = @" 小时";//负数的后缀
    ChartDefaultValueFormatter * formatter       = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    data.valueFormatter                          = formatter;
    data.valueFont                               = [UIFont systemFontOfSize:13];
    data.valueTextColor                          = LColor(@"0x515254");
    
    
    //x轴自定义
    LXGXAxisRenderer * xAxisRenderer                = [[LXGXAxisRenderer alloc]initWithViewPortHandler:self.bchartView.viewPortHandler xAxis:self.bchartView.xAxis transformer:[self.bchartView getTransformerForAxis:leftAxis.axisDependency]];
    xAxisRenderer.drawImagesEnabled                 = NO;
    xAxisRenderer.selectedXLabelTextColor           = LColor(@"#8bdba7");
    xAxisRenderer.selectedEntryX                    = @(1);
    self.bchartView.xAxisRenderer                   = xAxisRenderer;
    //
    ChartXAxis * xxAxis                          = self.bchartView.xAxis;
    xxAxis.labelCount                            = names.count;
    xxAxis.valueFormatter                        = [[ChartIndexAxisValueFormatter alloc] initWithValues:names];//X轴内容
    self.bchartView.data                         = data;
    [self.bchartView animateWithYAxisDuration:2.0f];//设置动画效果，可以设置X轴和Y轴的动画效果
     //[barChartView moveViewToX:20];//延x轴移动的距离
//    self.bchartView highlightValue:(ChartHighlight * _Nullable)
    [self.bchartView setVisibleXRangeMaximum:5];
    BarChartDataEntry * entry = yVals[1];
    self.selectindex = 1;
    [self.bchartView highlightValueWithX:entry.x y:entry.y dataSetIndex:0 dataIndex:1 callDelegate:NO];//单个有效  触发 drawBarChartHighlightShapeWithContext
}
- (void)drawBarChartShapeWithContext:(CGContextRef)context barRect:(CGRect)barRect index:(NSInteger)index{
    CGMutablePathRef path = CGPathCreateMutable();
    [self drawBaseBarShapeWithContext:context barRect:barRect path:path];
    [self drawLinearGradient:context path:path isVerticalGredient:YES select:YES index:index];// select:YES 选中指定的
}
- (void)drawBarChartHighlightShapeWithContext:(CGContextRef)context barRect:(CGRect)barRect index:(NSInteger)index{
    //self.selectindex      = index;//点击那个选中那个
    CGMutablePathRef path = CGPathCreateMutable();
    [self drawBaseBarShapeWithContext:context barRect:barRect path:path];
    [self drawLinearGradient:context path:path isVerticalGredient:YES select:YES index:index];
}
- (void)drawBaseBarShapeWithContext:(CGContextRef)context barRect:(CGRect)barRect path:(CGMutablePathRef)path{
    //1
//    CGPathAddRect(path, nil, barRect);//
//    CGContextAddPath(context, path);
//    CGContextFillPath(context);
//    CGContextSaveGState(context);
    //
    CGFloat y            = barRect.origin.y;//
    CGFloat x            = barRect.origin.x;//
    CGFloat barWidth     = barRect.size.width;
    CGFloat barHeight    = barRect.size.height;
    //2
    CGPathMoveToPoint(path, nil, x, y+5);
    CGPathAddArcToPoint(path, nil, x, y, x+5, y, 5);
    CGPathAddArcToPoint(path, nil, x+barWidth, y, x+barWidth, y+5, 5);
    CGPathAddLineToPoint(path, nil, x+barWidth, y+barHeight);
    CGPathAddLineToPoint(path, nil, x, y+barHeight);
    CGPathAddLineToPoint(path, nil, x, y+5);
    //3
//    CGContextMoveToPoint(context, x, y+5);
//    CGContextAddArcToPoint(context, x, y, x+5, y, 5);
//    CGContextAddArcToPoint(context, x+barWidth, y, x+barWidth, y+5, 5);
//    CGContextAddLineToPoint(context, x+barWidth, y+barHeight);
//    CGContextAddLineToPoint(context, x, y+barHeight);
//    CGContextAddLineToPoint(context, x, y+5);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextSaveGState(context);
}
- (void)drawLinearGradient:(CGContextRef)context path:(CGMutablePathRef)path isVerticalGredient:(BOOL)isVerticalGredient select:(BOOL)select index:(NSInteger)index{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[]    = {0.3, 0.7};
    NSString * clo1 = @"";
    NSString * clo2 = @"";
    if (select && self.selectindex == index) {
        clo1 = @"#8bdba7";
        clo2 = @"#51c575";
    }else{
        clo1 = @"#FC6C32";
        clo2 = @"#44FCA4";
    }
    NSArray *colors        = @[(__bridge id) LColor(clo1).CGColor, (__bridge id) LColor(clo2).CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect        = CGPathGetBoundingBox(path);
    CGPoint startPoint, endPoint;
    if (isVerticalGredient) {
        startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
        endPoint   = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    } else {
        startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
        endPoint   = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    }
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}









////饼状图
//-(void)bing{
//    self.pchartView           = [[PieChartView alloc]init];
//    self.pchartView.delegate  = self;
//    [self.view addSubview:self.pchartView];
//    [self.pchartView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.left.equalTo(self.view).offset(10);
//        make.right.equalTo(self.view).offset(-10);
//        make.height.equalTo(self.pchartView.mas_width);
//    }];
//    [self.pchartView setExtraOffsetsWithLeft:20 top:20 right:20 bottom:20];
//    //饼状图交互
//    self.pchartView.highlightPerTapEnabled          = YES;//是否可点击 点击时显示高亮的标志位
//    self.pchartView.dragDecelerationEnabled         = YES;//是否可拖拽 拖拽时允许减速的标志位
//    self.pchartView.dragDecelerationFrictionCoef    = 0.9;//拖拽减速的摩擦系数
//    self.pchartView.rotationEnabled                 = YES;//是否可以选择旋转
//    //是否显示饼状图名字
//    self.pchartView.chartDescription.enabled        = YES;
//    self.pchartView.chartDescription.text           = @"我是饼状图";
//    self.pchartView.chartDescription.textColor      = [UIColor redColor];
//    self.pchartView.chartDescription.textAlign      = NSTextAlignmentLeft;
//    self.pchartView.chartDescription.xOffset        = 50;//饼状图名字x轴偏移 正 左移 负 右移
//    //图例
//    self.pchartView.legend.enabled                 = YES;
//    self.pchartView.legend.maxSizePercent          = 1;//图例宽占比
//    self.pchartView.legend.formToTextSpace         = 5; //图示和文字的间隔
//    self.pchartView.legend.font                    = [UIFont systemFontOfSize:10];//图例字体大小
//    self.pchartView.legend.textColor               = [UIColor blackColor];//图例字体颜色
//    self.pchartView.legend.form                    = ChartLegendFormSquare;//图示样式: 方形、线条、圆形
//    self.pchartView.legend.formSize                = 10;//图示大小
//    //饼状图没有数据的显示
//    self.pchartView.noDataText                     = @"暂无数据";
//    self.pchartView.noDataTextColor                = LColor(@"0x21B7EF");
//    self.pchartView.noDataFont                     = [UIFont fontWithName:@"PingFangSC" size:15];
//    //饼状图是否显示空心圆
//    self.pchartView.drawHoleEnabled                = YES;
//    self.pchartView.drawCenterTextEnabled          = YES;//中心文字显示
//    self.pchartView.centerText                     = @"我是中心";
//    self.pchartView.drawEntryLabelsEnabled         = YES;//是否显示扇形区块文本描述
//    self.pchartView.usePercentValuesEnabled        = YES;//扇形区块文本百分比显示
//    self.pchartView.holeRadiusPercent              = 0.4;//第一个空心圆半径占比
//    self.pchartView.holeColor                      = [UIColor whiteColor];
//    self.pchartView.transparentCircleRadiusPercent = 0.5;//第二个空心圆半径占比
//    self.pchartView.transparentCircleColor         = LColor(@"0xf1f1f1");
//    //数据
//    NSArray * numbers       = @[@"10",@"20",@"30",@"40"];
//    NSArray * names         = @[@"情况1",@"情况2",@"情况3",@"情况4"];
//    NSMutableArray * values = [[NSMutableArray alloc] init];
//    for (int i = 0; i < numbers.count; i++){
//        //[values addObject:[[PieChartDataEntry alloc]initWithValue:[_numbers[i] doubleValue] label:_names[i] icon:nil]];
//        [values addObject:[[PieChartDataEntry alloc] initWithValue:[numbers[i] doubleValue] label:names[i] data:[NSString stringWithFormat:@"%d",i]]];
//    }
//    PieChartDataSet * dataSet = [[PieChartDataSet alloc] initWithEntries:values label:@"图列名字"];
//    dataSet.colors            = @[LColor(@"0x7AAAD8"),LColor(@"0xFFB22C"),LColor(@"0x7ECBC3"),LColor(@"0xB1ACDA")];
//    dataSet.sliceSpace        = 5;//相邻区块之间的间距
//    dataSet.selectionShift    = 12;//选中区块时, 放大的半径
//    dataSet.drawIconsEnabled  = NO;//扇形区块是否显示图片
//    dataSet.entryLabelColor   = [UIColor redColor];//每块扇形文字描述的颜色
//    dataSet.entryLabelFont    = [UIFont systemFontOfSize:15];//每块扇形的文字字体大小
//    dataSet.drawValuesEnabled = YES;//是否显示每块扇形的数值
//    dataSet.valueFont         = [UIFont systemFontOfSize:11];//每块扇形数值的字体大小
//    dataSet.valueColors       = @[[UIColor redColor],[UIColor cyanColor],[UIColor greenColor],[UIColor grayColor]];//每块扇形数值的颜色,如果数值颜色要一样，就设置一个色就好了
//    BOOL isValueLine                           = YES;//是否显示折线
//    if (isValueLine) {////////受到 中心圆的影响 半径越大 线越长
//        dataSet.xValuePosition                 = PieChartValuePositionInsideSlice;//文字的位置
//        dataSet.yValuePosition                 = PieChartValuePositionOutsideSlice;//数值的位置，只有在外面的时候，折线才有用
//        dataSet.valueLinePart1OffsetPercentage = 0.75;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
//        dataSet.valueLinePart1Length           = 0.4;//折线中第一段长度占比
//        dataSet.valueLinePart2Length           = 0.6;//折线中第二段长度占比
//        dataSet.valueLineWidth                 = 2;//折线的粗细
//        dataSet.valueLineColor                 = [UIColor redColor];//折线颜色
//        dataSet.valueLineVariableLength        = YES;
//    }
//    //设置每块扇形数值的格式
//    NSNumberFormatter * pFormatter             = [[NSNumberFormatter alloc] init];
//    pFormatter.numberStyle                     = NSNumberFormatterPercentStyle;
//    pFormatter.maximumFractionDigits           = 1;
//    pFormatter.multiplier                      = @1.f;
//    pFormatter.percentSymbol                   = @" %";
//    dataSet.valueFormatter                     = [[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter];
//    PieChartData * data                        = [[PieChartData alloc] initWithDataSet:dataSet];
//    self.pchartView.data                       = data;
//    self.pchartView.rotationAngle              = 0.0;//动画开始时的角度在0度
//    [self.pchartView animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
//}
@end
