//
//  AssetsHelper.m
//  PhotoEdit
//
//  Created by flyrees on 2018/1/18.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "AssetsHelper.h"

@implementation AssetsHelper

- (PHFetchResult<PHAsset *> *)getImageAssetsArray {
    //获取资源时的参数,可以传 nil 即使使用系统默认值
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //按照创建时间倒序排列图片
    options.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"ascending:NO]];
    //    获取资源 fetchAssetsWithMediaType：所获取的资源类型 PHAssetMediaTypeImage（获取所有图片资源）
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    return fetchResult;
}
- (PHFetchResult<PHAssetCollection *> *)gainAllImageAssetCollection {
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    return smartAlbums;
}
- (PHFetchResult<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return result;
}
- (PHFetchResult<PHAssetCollection *> *)gainUserCreateImageAssetCollection {
    //获取用户自己创建的所有智能相册
    PHFetchResult *userSmartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    return userSmartAlbums;
}

@end

