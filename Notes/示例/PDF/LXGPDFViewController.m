//
//  LXGPDFViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/11/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGPDFViewController.h"
#import <WebKit/WebKit.h>
#import <QuickLook/QuickLook.h>
@interface LXGPDFViewController ()<QLPreviewControllerDataSource>
@property (strong, nonatomic)QLPreviewController * previewController;
@property (strong, nonatomic)NSArray * dataArray;
@end
@implementation LXGPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self two];
}
//方法1
-(void)one{
    WKWebView * webView  = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    
    NSURL * filePath = [NSURL URLWithString:@"http://61.185.209.72:10002/Files/Weather/SWP/Product/W_SX_NQZB/2019/09/25/62A9CF3F285D4A80AFB996B5256BA371.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [webView loadRequest:request];
}
//方法2
-(void)two{
    self.dataArray = @[@"timg"];
    
    self.previewController            = [[QLPreviewController alloc] init];
    self.previewController.dataSource = self;
    [self.navigationController pushViewController:self.previewController animated:YES];
  //  [self.previewController refreshCurrentPreviewItem];
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.dataArray.count;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSString * urlStr   = [[NSBundle mainBundle]pathForResource:self.dataArray[index] ofType:@"jpg"];
    NSURL    * filePath = [NSURL URLWithString:urlStr];
    return filePath;
}
@end
//UIGraphicsBeginPDFContextToData
