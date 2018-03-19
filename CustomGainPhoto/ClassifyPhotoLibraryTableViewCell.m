//
//  ClassifyPhotoLibraryTableViewCell.m
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "ClassifyPhotoLibraryTableViewCell.h"
#import <objc/objc.h>

@implementation ClassifyPhotoLibraryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.numberLab];
        
        NSDictionary *dict = @{@"image":self.iconImageView, @"num":self.numberLab};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[image(70)]-5-[num]-5-|" options:0 metrics:nil views:dict]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[image]-5-|" options:0 metrics:nil views:@{@"image":self.iconImageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[num]-5-|" options:0 metrics:nil views:@{@"num":self.numberLab}]];
    }
    return self;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconImageView;
}
- (UILabel *)numberLab {
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLab.translatesAutoresizingMaskIntoConstraints = NO;
        _numberLab.textAlignment = NSTextAlignmentLeft;
        [_numberLab setTextColor:[UIColor blackColor]];
        [_numberLab setFont:[UIFont systemFontOfSize:16.]];
    }
    return _numberLab;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
