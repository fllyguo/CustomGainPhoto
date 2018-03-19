//
//  AssetsHelper.h
//  PhotoEdit
//
//  Created by flyrees on 2018/1/18.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "AlbumItem.h"

@interface AssetsHelper : NSObject
/**
 * 相册所有图片对象
 * 按照创建时间倒序排列
 */
- (PHFetchResult<PHAsset *> *)getImageAssetsArray;
/**
 * 获取所有系统相册集
 */
- (PHFetchResult<PHAssetCollection *> *)gainAllImageAssetCollection;
/**
 * 获取相册集内的所有照片资源
 */
- (PHFetchResult<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection;
/**
 * 获取所有用户自己创建的相册
 */
- (PHFetchResult<PHAssetCollection *> *)gainUserCreateImageAssetCollection;

@end
