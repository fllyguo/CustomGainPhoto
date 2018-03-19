//
//  TrimVideoViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/2/2.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "TrimVideoViewController.h"
#import "YGCTrimVideoView.h"

@interface TrimVideoViewController ()<YGCTrimVideoViewDelegate>
@property (nonatomic, strong)UIButton *editBut; /* 剪辑 */
@property (nonatomic, strong)UIButton *cancelBut; /* 取消 */

@property (nonatomic, strong)UIView *previewContainer;
@property (nonatomic, strong)YGCTrimVideoView *ygcTrimView;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerItem *originItem;
@property (nonatomic, strong)AVPlayerItem *playerItem;
@property (nonatomic, strong)AVPlayerLayer *playerLayer;

@end

@implementation TrimVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.previewContainer];
    [self.view addSubview:self.cancelBut];
    [self.view addSubview:self.editBut];
    
    self.originItem = [[AVPlayerItem alloc] initWithURL:self.URL];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.originItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.previewContainer.layer addSublayer:self.playerLayer];
    self.ygcTrimView = [[YGCTrimVideoView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 70, self.view.bounds.size.width, 70) assetURL:self.URL];
    self.ygcTrimView.delegate = self;
    [self.view addSubview:self.ygcTrimView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player play];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.playerLayer.frame = self.previewContainer.bounds;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)previewContainer {
    if (!_previewContainer) {
        _previewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _previewContainer.backgroundColor = [UIColor blackColor];
    }
    return _previewContainer;
}
- (UIButton *)editBut {
    if (!_editBut) {
        _editBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBut.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 35, 45, 25);
        [_editBut setTitle:@"剪辑" forState:UIControlStateNormal];
        _editBut.titleLabel.font = [UIFont systemFontOfSize:16.];
        [_editBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_editBut addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBut;
}
- (UIButton *)cancelBut {
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake(20, 32, 25, 25);
        [_cancelBut setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [_cancelBut addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}
- (void)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)editClick:(UIButton *)sender {
    NSLog(@"as");
}
#pragma mark ------- deleagte
- (void)videoBeginTimeChanged:(CMTime)begin {
    if ([self.player currentItem] != self.originItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.originItem];
    }
    [self.player seekToTime:begin completionHandler:^(BOOL finished) {
        
    }];
}
- (void)videoEndTimeChanged:(CMTime)end {
    if ([self.player currentItem] != self.originItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.originItem];
    }
    [self.player seekToTime:end completionHandler:^(BOOL finished) {
        
    }];
}
- (void)dragActionEnded:(AVMutableComposition *)asset {
    self.playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.player play];
}

@end
