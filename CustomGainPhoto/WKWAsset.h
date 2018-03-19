//
//  WKWAsset.h
//  PhotoEdit
//
//  Created by flyrees on 2018/1/18.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface WKWAsset : NSObject

/**
 * 获取相册中的视频文件
 */
/* 目前因为始终因为返回为空，没有是使用 */
//- (NSURL *)originalVideo:(PHAsset *)asset;
/**
 * 获取原图
 */
- (UIImage *)originalImage:(PHAsset *)asset;
/**
 * 获取缩略图
 */
- (UIImage *)smallImageSize:(CGSize)size asset:(PHAsset *)asset;
/**
 * 获取图片 NSData (包括 gif)
 */
- (NSData *)originalImageData:(PHAsset *)asset;


@end
