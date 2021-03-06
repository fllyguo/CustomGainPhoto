//
//  ViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/1/22.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import "ViewController.h"
#import "TestLibrary-Swift.h"
#import "ClassifyPhotoLibraryViewController.h"
#import "EditViewController.h" /* 图片编辑 */
#import "TrimVideoViewController.h" /* 视频剪辑 */
#import "GifViewController.h"/* 动图播放 */

@interface ViewController ()<moreInfoDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchThree;
@property (nonatomic, assign)BOOL isNoEmtpy;
@property (nonatomic, assign)BOOL isShowVideo;
@property (nonatomic, assign)BOOL isType;
@property (nonatomic, assign)BOOL isShowGif;
@property (nonatomic, assign)BOOL isShowMore;
@property (weak, nonatomic) IBOutlet UISwitch *switchFour;
@property (weak, nonatomic) IBOutlet UISwitch *switchFive;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _isNoEmtpy = YES;
    _isShowVideo = YES;
    _isType = YES;
    _isShowGif = YES;
    _isShowMore = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)select:(id)sender {
//    PhotoLibraryListViewController *vc = [[PhotoLibraryListViewController alloc] init];
//    vc.selectImage = ^(UIImage * image) {
//        NSLog(@"%@", image);
//    };
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
    //    __weak typeof(self)WeakSelf = self;
    ClassifyPhotoLibraryViewController *classifyVc = [[ClassifyPhotoLibraryViewController alloc] init];
    if (_isType == YES) {
        classifyVc.libraryType = AllLibraryPhoto;
    }else{
        classifyVc.libraryType = AllLibraryCollection;
    }
    classifyVc.delegate = self;
//    classifyVc.isNoReturnOriginal = YES;
    classifyVc.isNoEmpty = self.isNoEmtpy;//是否展示空相册
    classifyVc.isNoLibraryInVideo = self.isShowVideo;//是否展示视频
    classifyVc.isNoGifLibraryCpllection = self.isShowGif;//是否展示gif
    classifyVc.isNoMoreSelectFunction = self.isShowMore;
//    classifyVc.setMoreSelectNumber = 10;
//    __weak typeof (self)weakSelf = self;
    classifyVc.selectLibraryResourceBlock = ^(UIImage *image, NSURL *url, NSData *data) {
        NSLog(@"image:%@, url:%@, data:%@", image, url, data);
        UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
        //如果window已有弹出的视图，会导致界面无法弹出，页面卡死，这里需要先把视图关闭，再弹出
        if (fK.rootViewController.presentedViewController != nil) {
            [fK.rootViewController dismissViewControllerAnimated:NO completion:nil];
        }
        if (image != nil) {
            //测试使用，跳转操作
            EditViewController *editVc = [[EditViewController alloc] init];
            editVc.image = image;
            [fK.rootViewController presentViewController:editVc animated:YES completion:nil];
        }else if (url != nil){
            //测试使用、跳转操作
            TrimVideoViewController *trimVc = [[TrimVideoViewController alloc] init];
            trimVc.URL = url;
            [fK.rootViewController presentViewController:trimVc animated:YES completion:nil];
        }else{
            //测试使用，跳转操作
            GifViewController *gifVc = [[GifViewController alloc] init];
            gifVc.gifData = data;
            [fK.rootViewController.navigationController pushViewController:gifVc animated:YES];
        }
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:classifyVc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)retureMoreSelectInfoArr:(NSMutableArray *)infoArray {
    NSLog(@"%ld",infoArray.count);
}
- (IBAction)switchOneAction:(id)sender {
    if (self.switchOne.isOn) {
        NSLog(@"One-开");
        _isNoEmtpy = YES;
    }else{
        NSLog(@"One-关");
        _isNoEmtpy = NO;
    }
}
- (IBAction)switchTwoAction:(id)sender {
    if (self.switchTwo.isOn) {
        NSLog(@"Two-开");
        _isShowVideo = YES;
    }else{
        NSLog(@"Two-关");
        _isShowVideo = NO;
    }
}
- (IBAction)switchThreeAction:(id)sender {
    if (self.switchThree.isOn) {
        NSLog(@"Three-开");
        _isType = YES;
    }else{
        NSLog(@"Three-关");
        _isType = NO;
    }
}
- (IBAction)switchFourAction:(id)sender {
    if (self.switchFour.isOn) {
        NSLog(@"Four-开");
        _isShowGif = YES;
    }else{
        NSLog(@"Four-关");
        _isShowGif = NO;
    }
}
- (IBAction)switchFiveAction:(id)sender {
    if (self.switchFive.isOn) {
        NSLog(@"Five-开");
        _isShowMore = YES;
    }else{
        NSLog(@"Five-关");
        _isShowMore = NO;
    }
}

@end
