//
//  GifViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/2/5.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "GifViewController.h"
#import <SDWebImage/UIImage+GIF.h>

@interface GifViewController ()
@property (nonatomic, strong)UIImageView *gifImage;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.gifImage];
}
- (UIImageView *)gifImage {
    if (!_gifImage) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _gifImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _gifImage.center = self.view.center;
        _gifImage.backgroundColor = [UIColor redColor];
        _gifImage.image = [UIImage sd_animatedGIFWithData:self.gifData];
    }
    return _gifImage;
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
