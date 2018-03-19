//
//  WKWAsset.m
//  PhotoEdit
//
//  Created by flyrees on 2018/1/18.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "WKWAsset.h"

@implementation WKWAsset
/**
 * 获取视频文件
 */
- (NSURL *)originalVideo:(PHAsset *)asset {
    __block NSURL *resultURL;
    PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
    videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@", ((AVURLAsset *)asset).URL].length > 0) {
            resultURL = ((AVURLAsset *)asset).URL;
        }
        NSLog(@"----%@", resultURL);
    }];
    NSLog(@"====%@", resultURL);
    return resultURL;
}
/**
 * 获取原图
 */
- (UIImage *)originalImage:(PHAsset *)asset {
    __block UIImage *resultImage;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    return resultImage;
}
/**
 * 获取缩略图
 */
- (UIImage *)smallImageSize:(CGSize)size asset:(PHAsset *)asset {
    __block UIImage *resultImage;
    //初始化控制器图片请求操作的一些属性
    PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    //PHImageRequestOptionsResizeModeExact 则返回图像必须和目标大小相匹配，并且图像质量也为高质量图像
    imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    imageRequestOptions.synchronous = YES;
    
    CGSize imageSize = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
    //通过获取的图片资源信息  请求得到image信息
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    return resultImage;
}
/**
 * 获取图片 NSData (包括 gif)
 */
- (NSData *)originalImageData:(PHAsset *)asset {
    __block NSData *resultImageData;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = YES;
    //通过图片资源信息 请求得到image data
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        resultImageData = imageData;
    }];
    return resultImageData;
}

@end
