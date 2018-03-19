//
//  NSObject+PhotoJurisdiction.h
//  PhotoEdit
//
//  Created by flyrees on 2018/1/12.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

/* 相册权限设置 */
@interface NSObject (PhotoJurisdiction)
/*
 * 获取相册权限
 */
+ (void)requestPhotosLibraryAuthorizationStatus:(void(^)(BOOL status))AuStatus;
/*
 * 进入app设置页
 */
+ (void)openAppSetings;
/*
 * 颜色转图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
