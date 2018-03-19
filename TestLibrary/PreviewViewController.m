//
//  PreviewViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/1/26.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController ()
@property (nonatomic, strong)UIButton *cancelBut;
@property (nonatomic, strong)UIImageView *imageV;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.cancelBut];
}
- (UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithImage:self.image];
        _imageV.center = self.view.center;
    }
    return _imageV;
}
- (UIButton *)cancelBut {
    if (!_cancelBut) {
        _cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBut.frame = CGRectMake(0, 0, 35, 35);
        _cancelBut.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height - 50);
        _cancelBut.layer.cornerRadius = 35/2;
        _cancelBut.layer.masksToBounds = YES;
        [_cancelBut setImage:[UIImage imageNamed:@"cancel_back"] forState:UIControlStateNormal];
        [_cancelBut addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBut;
}
- (void)cancelClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
