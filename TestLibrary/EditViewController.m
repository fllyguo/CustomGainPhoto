//
//  EditViewController.m
//  PhotoEdit
//
//  Created by flyrees on 2018/1/12.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "EditViewController.h"
#import "JPImageresizerView.h"
#import "PreviewViewController.h"

@interface EditViewController ()
@property (nonatomic, weak)JPImageresizerView *imageresizerView;
@property (nonatomic, strong)UIButton *tailorBut;//裁剪
@property (nonatomic, strong)UIButton *cancelBut;//取消
@property (nonatomic, strong)UIButton *rotateBut;//旋转
@property (nonatomic, strong)UIButton *typeBut;//拖拽边框类型
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self JPImageresizer];
    [self butFlexBox];
}
//图片剪裁
- (void)JPImageresizer {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, (40 + 30 + 30 + 10), 0);
    JPImageresizerConfigure *configure = [JPImageresizerConfigure defaultConfigureWithResizeImage:self.image make:^(JPImageresizerConfigure *configure) {
        configure.jp_resizeImage(self.image).jp_maskAlpha(0.7).jp_strokeColor([UIColor yellowColor]).jp_frameType(JPClassicFrameType).jp_contentInsets(contentInsets).jp_bgColor([UIColor colorWithRed:arc4random() % 254 / 255. green:arc4random() % 254 / 255. blue:arc4random() % 254 / 255. alpha:1]).jp_isClockwiseRotation(YES).jp_animationCurve(JPAnimationCurveEaseOut);
    }];
    
    self.view.backgroundColor = configure.bgColor;
    
    self.tailorBut.enabled = NO;
    __weak typeof(self) wSelf = self;
    self.imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) {
            return;
        }
        // 当不需要重置设置按钮不可点
        sSelf.tailorBut.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) {
            return;
        }
        // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
        sSelf.rotateBut.enabled = enabled;
        sSelf.tailorBut.enabled = enabled;
    }];
    [self.view insertSubview:self.imageresizerView atIndex:0];
    configure = nil;
}
//确定裁剪
- (UIButton *)tailorBut {
    if (!_tailorBut) {
        _tailorBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _tailorBut.translatesAutoresizingMaskIntoConstraints = NO;
        [_tailorBut setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
        [_tailorBut addTarget:self action:@selector(tailorClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tailorBut;
}
//取消
- (UIButton *)cancelBut {
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelBut setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelBut addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}
//旋转
- (UIButton *)rotateBut {
    if (!_rotateBut) {
        _rotateBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotateBut.translatesAutoresizingMaskIntoConstraints = NO;
        [_rotateBut setImage:[UIImage imageNamed:@"rotate"] forState:UIControlStateNormal];
        [_rotateBut addTarget:self action:@selector(rotateClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rotateBut;
}
//拖拽边框类型
- (UIButton *)typeBut {
    if (!_typeBut) {
        _typeBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeBut.translatesAutoresizingMaskIntoConstraints = NO;
        [_typeBut setImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
        [_typeBut addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBut;
}
- (void)butFlexBox {
//    [self.view configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
//        layout.isEnabled = YES;
//        layout.justifyContent = YGJustifySpaceBetween;
//        layout.justifyContent = YGEdgeLeft;
//    }];
//    [self.view addSubview:self.cancelBut];
//    [self.view.yoga applyLayoutPreservingOrigin:YES];
//    [self.cancelBut configureLayoutWithBlock:^(YGLayout * _Nonnull layout) {
//        layout.isEnabled = YES;
//    }];
    
    [self.view addSubview:self.cancelBut];
    [self.view addSubview:self.typeBut];
    [self.view addSubview:self.tailorBut];
    [self.view addSubview:self.rotateBut];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[cancel(25)]" options:0 metrics:nil views:@{@"cancel":_cancelBut}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancel(25)]-30-|" options:0 metrics:nil views:@{@"cancel":_cancelBut}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[tailor(25)]-30-|" options:0 metrics:nil views:@{@"tailor":_tailorBut}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tailor(25)]-30-|" options:0 metrics:nil views:@{@"tailor":_tailorBut}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_rotateBut attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[rotate(25)]" options:0 metrics:nil views:@{@"rotate":_rotateBut}]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[type(20)]" options:0 metrics:nil views:@{@"type":_typeBut}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_typeBut attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[type(20)]-16-[rotate(25)]-30-|" options:0 metrics:nil views:@{@"type":_typeBut, @"rotate":_rotateBut}]];
}

//确定裁剪
- (void)tailorClick:(UIButton *)sender {
    PreviewViewController *tailorVc = [[PreviewViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            return;
        }
        tailorVc.image = resizeImage;
        [self presentViewController:tailorVc animated:YES completion:nil];
    }];
}
//取消裁剪
- (void)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//旋转
- (void)rotateClick:(UIButton *)sender {
    // 默认逆时针旋转，旋转角度为90°
    [self.imageresizerView rotation];
    // 若需要顺时针旋转可设置isClockwiseRotation属性为YES
//    self.imageresizerView.isClockwiseRotation = YES;
}
//拖拽边框类型切换
- (void)typeClick:(UIButton *)sender {
    if (sender.selected == NO) {
        self.imageresizerView.frameType = JPConciseFrameType;
        sender.selected = YES;
    }else{
        self.imageresizerView.frameType = JPClassicFrameType;
        sender.selected = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
