//
//  AllPhotoLibraryCollectionViewCell.h
//  TestLibrary
//
//  Created by flyrees on 2018/2/6.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectLibraryResourceDelegate <NSObject>//选择照片的资源协议

- (void)selectSomeResourceIndexRowBut:(UIButton *)indexBut;

@end

@interface AllPhotoLibraryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *backImg;
@property (nonatomic, strong)UIButton *selectBut;
@property (nonatomic, assign)id<selectLibraryResourceDelegate>delegate;

@end
