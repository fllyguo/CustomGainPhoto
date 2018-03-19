//
//  NSObject+PhotoJurisdiction.m
//  PhotoEdit
//
//  Created by flyrees on 2018/1/12.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "NSObject+PhotoJurisdiction.h"

@implementation NSObject (PhotoJurisdiction)
+ (void)requestPhotosLibraryAuthorizationStatus:(void (^)(BOOL))AuStatus {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                    //已获取权限
                case PHAuthorizationStatusAuthorized:
                    NSLog(@"已获取");
                    //获取权限返回
                    AuStatus(YES);
                    break;
                    //拒绝打开应用程序
                case PHAuthorizationStatusDenied:
                    NSLog(@"用户已经明确否认了这一照片数据的应用程序访问");
                    AuStatus(NO);
                    break;
                    //此应用程序没有被授权访问的照片数据。可能是家长控制权限
                case PHAuthorizationStatusRestricted:
                    NSLog(@"此应用程序没有被授权访问的照片数据");
                    break;
                default:
                    break;
            }
        });
    }];
}
+ (void)openAppSetings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
        }
    }else{
        NSLog(@"无法打开设置");
    }
}
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsGetCurrentContext();
    return image;
}

@end
