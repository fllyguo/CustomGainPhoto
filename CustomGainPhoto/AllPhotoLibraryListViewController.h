//
//  AllPhotoLibraryListViewController.h
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "AlbumItem.h"
@protocol selectImageDelegate <NSObject>//协议

/** 点击选择 正常图片返回UIImage、视频返回url、gif图片返回NSData **/
- (void)selectPhotoLibraryImage:(UIImage *)image;/* UIImage */
- (void)selectVideosUrl:(NSURL *)url; /* 视频url */
- (void)selectGifImageData:(NSData *)data;/* gifdata */
- (void)reloadLibraryCollention; /* 刷新相册集合 */
/** 多项选择，返回资源数据数组 **/
- (void)moreSelectInfoArray:(NSMutableArray *)infoArr;

@end

@interface AllPhotoLibraryListViewController : UIViewController

@property (nonatomic, assign)BOOL isNoReturnOr;//是否返回原图
@property (nonatomic, assign)BOOL isNoDirectAccess;//是否直接进入所有照片
@property (nonatomic, assign)BOOL isNoShowMore;//是否展示多选功能
@property (nonatomic, assign)NSInteger setMoreNum;//设置多选数量
@property (nonatomic, strong)AlbumItem *assetsModel;//图片信息
@property (nonatomic, assign)id<selectImageDelegate>delegate;

@end
