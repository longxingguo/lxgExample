//
//  LXGAlbumManager.m
//  LXGDemo合集
//
//  Created by onecar on 2019/4/19.
//  Copyright © 2019 onecar. All rights reserved.
//

#import "LXGAlbumManager.h"
#import "LXGPhotoManger.h"
#import "LXGAlbumViewController.h"
@implementation LXGAlbumManager
+(void)showPhotosManager:(UIViewController *)viewController withMaxImageCount:(NSInteger)maxCount withAlbumArray:(void(^)(NSMutableArray<LXGPhotoModel *> *albumArray))albumArray{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {//同意
                LXGAlbumViewController * controller = [[LXGAlbumViewController alloc] init];
                controller.AlbumConfirmAction = ^{
                    albumArray([LXGPhotoManger standardPhotoManger].photoModelList);
                };
                UINavigationController *navigationController  = [[UINavigationController alloc] initWithRootViewController:controller];
                [LXGPhotoManger standardPhotoManger].maxCount = maxCount;
                [viewController presentViewController:navigationController animated:YES completion:nil];
            }else{//不同意
                UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"访问相册" message:@"您还没有打开相册权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                }];
                [alertViewController addAction:action1];
                [alertViewController addAction:action2];
                [viewController presentViewController:alertViewController animated:YES completion:nil];
            }
        });
    }];
}
@end
/* PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
 switch (status){
 case PHAuthorizationStatusNotDetermined:{//不知
 [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
 dispatch_async(dispatch_get_main_queue(), ^{
 });
 }];
 }break;
 case PHAuthorizationStatusRestricted://限制
 case PHAuthorizationStatusDenied:{//拒绝
 //            NSString * tips = [NSString stringWithFormat:@"“%@“无法访问您的相册，请在iPhone的”设置-隐私-相册“选项中，允许“%@“访问你的手机相册",[self getAppName],[self getAppName]];
 //            [self showAlertViewControllerWithTitle:tips];
 }break;
 case PHAuthorizationStatusAuthorized:{//允许
 //  [self takePhoto];
 }break;
 default:
 break;
 }*/
