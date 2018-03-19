//
//  AllPhotoLibraryCollectionViewCell.m
//  TestLibrary
//
//  Created by flyrees on 2018/2/6.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "AllPhotoLibraryCollectionViewCell.h"

@implementation AllPhotoLibraryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backImg];
        [self.contentView addSubview:self.selectBut];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backImage]|" options:0 metrics:nil views:@{@"backImage":self.backImg}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backImage]|" options:0 metrics:nil views:@{@"backImage":self.backImg}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectBut(27)]|" options:0 metrics:nil views:@{@"selectBut":self.selectBut}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selectBut(27)]" options:0 metrics:nil views:@{@"selectBut":self.selectBut}]];
    }
    return self;
}
- (UIImageView *)backImg {
    if (!_backImg) {
        _backImg = [[UIImageView alloc] init];
        _backImg.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backImg;
}
- (UIButton *)selectBut {
    if (!_selectBut) {
        _selectBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBut.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectBut setImage:[UIImage imageNamed:@"noSelect"] forState:UIControlStateNormal];
        [_selectBut setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_selectBut addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBut;
}
- (void)selectClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(selectSomeResourceIndexRowBut:)]) {
        [self.delegate selectSomeResourceIndexRowBut:sender];
    }
}

@end
