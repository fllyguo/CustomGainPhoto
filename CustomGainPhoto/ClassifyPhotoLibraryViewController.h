//
//  ClassifyPhotoLibraryViewController.h
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AllLibraryPhoto,//所有照片
    AllLibraryCollection,//相册集
} VisitLibraryType;

typedef void(^selectLibraryBlock)(UIImage *image, NSURL *url, NSData *data);/* UIImage image */

@protocol moreInfoDelegate <NSObject>//多选返回资源数据代理

- (void)retureMoreSelectInfoArr:(NSMutableArray *)infoArray;

@end

@interface ClassifyPhotoLibraryViewController : UIViewController
/**
 * 返回选择有可能资源类型、其中俩个必为空
 * UIImage image
 * Videos url
 * Gif NSData
 */
@property (nonatomic, copy)selectLibraryBlock selectLibraryResourceBlock;
/**
 * 多选资源 delegate
 */
@property (nonatomic, assign)id<moreInfoDelegate>delegate;
/**
 * 是否获取相册中的视频 默认 不获取 (YES 获取，NO 不获取)
 */
@property (nonatomic, assign)BOOL isNoLibraryInVideo;
/**
 * 是否展示空相册 默认 不展示 (YES 展示， NO 不展示)
 */
@property (nonatomic, assign)BOOL isNoEmpty;
/**
 * 是否展示 gif 相册集 默认 不展示 (YES 展示，NO不展示)
 */
@property (nonatomic, assign)BOOL isNoGifLibraryCpllection;
/**
 * 是否展示 资源多选功能 默认不展示 (YES 展示， NO不展示)
 */
@property (nonatomic, assign)BOOL isNoMoreSelectFunction;
/**
 * 设置多选最多可以选择资源数量 （目前还没处理好，不能使用）
 */
@property (nonatomic, assign)NSInteger setMoreSelectNumber;
/**
 * 先展示相册类型 (默认先展示，所有照片)
 */
@property (nonatomic, assign)VisitLibraryType libraryType;

@end
