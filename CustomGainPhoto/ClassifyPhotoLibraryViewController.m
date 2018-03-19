//
//  ClassifyPhotoLibraryViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ClassifyPhotoLibraryViewController.h"
#import "AllPhotoLibraryListViewController.h"
#import "ClassifyPhotoLibraryTableViewCell.h"
#import "WKWAsset.h"
#import "AssetsHelper.h"
#import "NSObject+PhotoJurisdiction.h"
#import "AlbumItem.h"

@interface ClassifyPhotoLibraryViewController ()<UITableViewDelegate,UITableViewDataSource,selectImageDelegate>
@property (nonatomic, strong)UITableView *classifyTab;//相册分类
@property (nonatomic, strong)NSMutableArray *assetsArray;//相册数组
@property (nonatomic, strong)AlbumItem *albumItemModel;//相册信息

@end

@implementation ClassifyPhotoLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //获取相册权限
    [NSObject requestPhotosLibraryAuthorizationStatus:^(BOOL status) {
        if (status == YES) {
            //进入push 到 allVc页
            //要是访问的是所有图片，直接跳转下一页展示，如果不是，则展示相册集
            __weak typeof(self)weakSelf = self;
            if (self.libraryType == AllLibraryPhoto) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AllPhotoLibraryListViewController *allVc = [[AllPhotoLibraryListViewController alloc] init];
                    allVc.title = @"相机胶卷";
                    allVc.isNoDirectAccess = YES;/* 直接进入所有照片 */
                    allVc.setMoreNum = self.setMoreSelectNumber;//设置数量
                    allVc.delegate = self;
                    if (self.isNoMoreSelectFunction == YES) {
                        allVc.isNoShowMore = YES;
                    }else{
                        allVc.isNoShowMore = NO;
                    }
                    [weakSelf.navigationController pushViewController:allVc animated:NO];
                });
            }else if (self.libraryType == AllLibraryCollection) {
                /** 如果设置为相册集，则直接获取相册集数据 **/
                [self createLibraryCollection];
            }
        }else{
            [self setingLibraryAuthorization];//打开设置
        }
    }];
}
- (UITableView *)classifyTab {
    if (!_classifyTab) {
        _classifyTab = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _classifyTab.translatesAutoresizingMaskIntoConstraints = NO;
        _classifyTab.backgroundColor = [UIColor whiteColor];
        _classifyTab.delegate = self;
        _classifyTab.dataSource = self;
        _classifyTab.rowHeight = 80;
    }
    return _classifyTab;
}
#pragma mark ----- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyPhotoLibraryTableViewCell *classifyCell = [tableView dequeueReusableCellWithIdentifier:@"classifyCellId"];
    if (!classifyCell) {
        classifyCell = [[ClassifyPhotoLibraryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classifyCellId"];
    }
    classifyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    WKWAsset *asset = [[WKWAsset alloc] init];
    AlbumItem *item = self.assetsArray[indexPath.row];
    UIImage *image = [asset smallImageSize:CGSizeMake(60, 60) asset:item.assets.firstObject];
    NSString *str = [NSString stringWithFormat:@"%@   (%ld)", item.photoTitle, item.assets.count];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:[NSString stringWithFormat:@"(%ld)", item.assets.count]];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.] range:rangel];
    [classifyCell.numberLab setAttributedText:textColor];
    
    if (image != nil) {
        classifyCell.iconImageView.image = image;
    }else{
        classifyCell.iconImageView.image = [UIImage imageNamed:@"libraryLogo"];
    }
    return classifyCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlbumItem *itemModel = self.assetsArray[indexPath.row];
    [self enterShowPhoto:NO albumModel:itemModel photoLibraryVcTitle:itemModel.photoTitle];
}
//UIImage 代理
- (void)selectPhotoLibraryImage:(UIImage *)image {
    if (image != nil) {
        self.selectLibraryResourceBlock(image, nil, nil);
    }
}
//Videos 代理
- (void)selectVideosUrl:(NSURL *)url {
    if (url != nil) {
        self.selectLibraryResourceBlock(nil, url, nil);
    }
}
//gif 代理
- (void)selectGifImageData:(NSData *)data {
    if (data != nil) {
        self.selectLibraryResourceBlock(nil, nil, data);
    }
}
//多选 代理
- (void)moreSelectInfoArray:(NSMutableArray *)infoArr {
    if ([self.delegate respondsToSelector:@selector(retureMoreSelectInfoArr:)]) {
        [self.delegate retureMoreSelectInfoArr:infoArr];
    }
}
//取消按钮方法
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSMutableArray *)assetsArray {
    if (!_assetsArray) {
        _assetsArray = [NSMutableArray array];
    }
    return _assetsArray;
}
//获取相册集
- (void)gainImageInfo {
    AssetsHelper *assetsHelper = [[AssetsHelper alloc] init];
    //获取系统相册集
    PHFetchResult *result = [assetsHelper gainAllImageAssetCollection];
    for (PHAssetCollection *collection in result) {
        [self isNoEmptyLibraryAndVideosAndGifLibraryCollection:collection assetsHelper:assetsHelper];
    }
    //获取用户自己创建相册集
    PHFetchResult *userResult = [assetsHelper gainUserCreateImageAssetCollection];
    for (PHAssetCollection *userCollection in userResult) {
        [self isNoEmptyLibraryAndVideosAndGifLibraryCollection:userCollection assetsHelper:assetsHelper];
    }
}
#pragma mark --- 判断是否展示空相册、是否展示视频、是否展示gif图
- (void)isNoEmptyLibraryAndVideosAndGifLibraryCollection:(PHAssetCollection *)collection assetsHelper:(AssetsHelper *)assetsHelper {
    //************* 展示空相册
    if (self.isNoEmpty == YES) {
        //--------- 展示视频
        if (self.isNoLibraryInVideo == YES) {
            //========= 展示gif
            if (self.isNoGifLibraryCpllection == YES) {
                [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
            } else {
                //=========不展示gif
                if (![collection.localizedTitle isEqualToString:@"动图"] && ![collection.localizedTitle isEqualToString:@"Animated"]) {
                    [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                }
            }
            
        }else{
            //--------- 不展示视频
            if (![collection.localizedTitle isEqualToString:@"视频"] && ![collection.localizedTitle isEqualToString:@"Videos"]) {
                //========= 展示gif
                if (self.isNoGifLibraryCpllection == YES) {
                    [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                } else {
                    //========= 不展示gif
                    if (![collection.localizedTitle isEqualToString:@"动图"] && ![collection.localizedTitle isEqualToString:@"Animated"]) {
                        [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                    }
                }
            }
        }
    }else{
        //************* 不展示空相册
        if ([assetsHelper getAssetsInAssetCollection:collection].count != 0) {
            //--------- 展示视频
            if (self.isNoLibraryInVideo == YES) {
                //========= 展示gif
                if (self.isNoGifLibraryCpllection == YES) {
                    [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                } else {
                    //========= 不展示gif
                    if (![collection.localizedTitle isEqualToString:@"动图"] && ![collection.localizedTitle isEqualToString:@"Animated"]) {
                        [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                    }
                }
                
            }else{
                //--------- 不展示视频
                if (![collection.localizedTitle isEqualToString:@"视频"] && ![collection.localizedTitle isEqualToString:@"Videos"]) {
                    //========= 展示gif
                    if (self.isNoGifLibraryCpllection == YES) {
                        [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                    } else {
                        //========= 不展示gif
                        if (![collection.localizedTitle isEqualToString:@"动图"] && ![collection.localizedTitle isEqualToString:@"Animated"]) {
                            [self gainLibraryGatherInPhotoCollection:collection helper:assetsHelper];
                        }
                    }
                }
            }
        }
    }
}
#pragma mark --- 获取相册集中的照片，添加到模型中
- (void)gainLibraryGatherInPhotoCollection:(PHAssetCollection *)collection helper:(AssetsHelper *)helper {
    _albumItemModel = [[AlbumItem alloc] init];
    _albumItemModel.photoTitle = collection.localizedTitle;
    _albumItemModel.assets = [helper getAssetsInAssetCollection:collection];
    [self.assetsArray addObject:_albumItemModel];
}
//跳转到照片展示页
- (void)enterShowPhoto:(BOOL)isNoDir albumModel:(AlbumItem *)itemModel photoLibraryVcTitle:(NSString *)title {
    AllPhotoLibraryListViewController *allVc = [[AllPhotoLibraryListViewController alloc] init];
    allVc.title = title;
    allVc.assetsModel = itemModel;
    allVc.isNoDirectAccess = isNoDir;/* 不是直接进入 */
    allVc.setMoreNum = self.setMoreSelectNumber;//设置多选数量
    allVc.delegate = self;
    if (self.isNoMoreSelectFunction == YES) {
        allVc.isNoShowMore = YES;
    }else{
        allVc.isNoShowMore = NO;
    }
    [self.navigationController pushViewController:allVc animated:YES];
}
/** 刷新相册集 **/
- (void)reloadLibraryCollention {
    [self createLibraryCollection];
}
//添加相册集UI、获取相册集数据
- (void)createLibraryCollection {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [self.view addSubview:self.classifyTab];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:@{@"tableView":_classifyTab}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:@{@"tableView":_classifyTab}]];
    [self gainImageInfo];//获取相册信息
}
//打开相册访问权限
- (void)setingLibraryAuthorization {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您未打开相册访问权限，去设置打开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NSObject openAppSetings];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
