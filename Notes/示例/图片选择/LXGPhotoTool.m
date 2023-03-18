//
//  LXGPhotoTool.m
//  LXGDemo
//
//  Created by 龙兴国 on 2019/8/2.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGPhotoTool.h"
#import <Photos/Photos.h>
#import <CoreServices/UTCoreTypes.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface LXGPhotoTool ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic ,copy)void(^completeImageBlock)(UIImage *image);
@property (nonatomic ,copy)void(^completeImageArrayBlock)(NSArray *imageArray);
@end
@implementation LXGPhotoTool
+(instancetype)sharePhotoTool{
    static LXGPhotoTool  * photoTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoTool = [LXGPhotoTool new];
    });
    return photoTool;
}
/**
 拍照获取图片
 @param allowCrop   是否可以剪裁
 @param complete    图片
 */
+(void)getPhotoAllowCrop:(BOOL)allowCrop andComplete:(void(^)(UIImage *image))complete{
    [LXGPhotoTool sharePhotoTool].completeImageBlock = complete;
    [self getPermissions:allowCrop];
}
+(void)getPermissions:(BOOL)allowCrop{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{//还未选择
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                [self getPermissions:allowCrop];
            }];
        }break;
        case AVAuthorizationStatusRestricted://限制
        case AVAuthorizationStatusDenied:{//拒绝
            NSString * tips = [NSString stringWithFormat:@"“%@“无法访问您的相机，请在iPhone的”设置-隐私-相册“选项中，允许“%@“访问你的手机相机",[self getAppName],[self getAppName]];
            [self showAlertViewControllerWithTitle:tips andIsSetting:YES];
        }break;
        case AVAuthorizationStatusAuthorized:{//允许
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                [self takePhotoWithAllowCrop:allowCrop];
            }else{
                [self showAlertViewControllerWithTitle:@"相机已损坏" andIsSetting:NO];
            }
        }break;
        default:
            break;
    }
}
+(void)showAlertViewControllerWithTitle:(NSString *)title andIsSetting:(BOOL)isSetting{
    LAlertOpenSetting(title);
}
+ (NSString *)getAppName{
    return [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleDisplayName"];
}
+(void)openSystemSetting{
    if (@available(iOS 8.0, *)){
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
             [self showAlertViewControllerWithTitle:@"无法跳转到设置页面，请手动前往设置" andIsSetting:NO];
        }
    }
}
+(void)takePhotoWithAllowCrop:(BOOL)allowCrop{
    UIImagePickerController * ImagePickerController = [[UIImagePickerController alloc]init];
    ImagePickerController.sourceType                = UIImagePickerControllerSourceTypeCamera;
    ImagePickerController.mediaTypes                = @[(NSString *)kUTTypeImage];// (NSString *)kUTTypeMovie  图片或 者是 视频
    ImagePickerController.allowsEditing             = allowCrop;
    ImagePickerController.delegate                  = [LXGPhotoTool sharePhotoTool];
    [LCurrentVC presentViewController:ImagePickerController animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString * type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:(NSString *)kUTTypeImage]){//[type isEqualToString:@"public.image"]
            UIImage * image = nil;
            if (picker.allowsEditing) {
                image = [info objectForKey:UIImagePickerControllerEditedImage];
            }else{
                image = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            if (self.completeImageBlock) {
                NSData  * data  = UIImageJPEGRepresentation(image, 0.5);
                self.completeImageBlock([UIImage imageWithData:data]);
            }
        }
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 相册获取图片
 @param photoNumber 几张
 @param allowCrop   是否可以剪裁
 @param complete    图片数组
 */
+(void)getPhotoWithPhotoNumber:(NSInteger)photoNumber AllowCrop:(BOOL)allowCrop andComplete:(void(^)(NSArray *imageArray))complete{
     [LXGPhotoTool sharePhotoTool].completeImageArrayBlock = complete;
      [self pushTZImagePickerControllerWithPhotoNumber:photoNumber andAllowCrop:allowCrop];
}
+(void)pushTZImagePickerControllerWithPhotoNumber:(NSInteger)photoNumber andAllowCrop:(BOOL)allowCrop{
    TZImagePickerController * ImagePickerController = [[TZImagePickerController alloc]initWithMaxImagesCount:photoNumber delegate:[LXGPhotoTool sharePhotoTool]];
    ImagePickerController.allowPickingOriginalPhoto = YES;
    ImagePickerController.allowPickingVideo         = NO;
    ImagePickerController.allowTakeVideo            = NO;
//    ImagePickerController.navigationBar.barTintColor = [UIColor greenColor];
//    ImagePickerController.navigationBar.translucent = NO;
    ImagePickerController.allowCrop                 = allowCrop;
    ImagePickerController.modalPresentationStyle    = UIModalPresentationFullScreen;
    [LCurrentVC presentViewController:ImagePickerController animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if (self.completeImageArrayBlock) {
        self.completeImageArrayBlock(photos);
    }
}
@end
