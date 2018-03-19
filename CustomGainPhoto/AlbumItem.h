//
//  AlbumItem.h
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AlbumItem : NSObject

@property (nonatomic, strong)NSString *photoTitle;//图片标题
@property (nonatomic, strong)PHFetchResult<PHAsset *> *assets;//图片信息

@end
