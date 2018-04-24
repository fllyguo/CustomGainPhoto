//
//  AllPhotoLibraryListViewController.m
//  TestLibrary
//
//  Created by flyrees on 2018/1/23.
//  Copyright © 2018年 flyrees. All rights reserved.
//
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
//判断iPhone还是iPad
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#import "AllPhotoLibraryListViewController.h"
#import "AllPhotoLibraryCollectionViewCell.h"
#import "UIViewController+BackButtonHandler.h"/* 系统返回按钮方法 */
#import "AssetsHelper.h"
#import "WKWAsset.h"
#import "AlbumItem.h"

//选择类型（选择还是删除选择）
typedef enum : NSUInteger {
    AddSelectRes,//选择资源
    RemoveSelectRes,//移除资源
} MoreSelectType;

@interface AllPhotoLibraryListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,selectLibraryResourceDelegate>
@property (nonatomic, strong)UICollectionView *collectionView;//全部照片展示
@property (nonatomic, assign)CGSize assetGridThumbnailSize;//缩略图大小
@property (nonatomic, strong)WKWAsset *assetObj;
@property (nonatomic, strong)NSMutableArray *addResArray;//点击选择的所有图片数组
@property (nonatomic, strong)NSMutableArray <NSNumber *>*isExpland;//用于判断是否选择
@property (nonatomic, assign)NSInteger addNum;//用于限制添加数量

@end

@implementation AllPhotoLibraryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    CGFloat sizeWidth = 0.0;
    if (SCREEN_WIDTH <= 375) {
        sizeWidth = SCREEN_WIDTH / 4 - 7;
    }else{
        sizeWidth = 95;
    }
    _assetGridThumbnailSize = CGSizeMake(sizeWidth, sizeWidth);//设置item大小
    [self.view addSubview:self.collectionView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView":_collectionView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:@{@"collectionView":_collectionView}]];
    
    // 直接进入 则 加载数据
    if (self.isNoDirectAccess == YES) {
        if (self.assetsModel.assets.count == 0) {
            [self getImages];//获取图片数据
        }
    }else{
        for (NSInteger i = 0; i < self.assetsModel.assets.count; i++) {
            [self.isExpland addObject:@0];
        }
    }
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = _assetGridThumbnailSize;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[AllPhotoLibraryCollectionViewCell class] forCellWithReuseIdentifier:@"photoCellId"];
    }
    return _collectionView;
}
#pragma mark ------collection Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsModel.assets.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AllPhotoLibraryCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCellId" forIndexPath:indexPath];
    PHAsset *asset = self.assetsModel.assets[indexPath.item];
    if (IS_IPHONE) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            UIImage *image = [self.assetObj smallImageSize:_assetGridThumbnailSize asset:asset];
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                if (image != nil) {
                    photoCell.backImg.image = image;
                    if (self.isNoShowMore == YES) {
                        photoCell.selectBut.hidden = NO;
                        photoCell.selectBut.tag = indexPath.item + 666;
                        photoCell.delegate = self;
                    }else{
                        photoCell.selectBut.hidden = YES;
                    }
                }
            });
        });
    }else{
        UIImage *image = [self.assetObj smallImageSize:_assetGridThumbnailSize asset:asset];
        if (image != nil) {
            photoCell.backImg.image = image;
            if (self.isNoShowMore == YES) {
                photoCell.selectBut.tag = indexPath.item + 666;
                photoCell.delegate = self;
                photoCell.selectBut.hidden = NO;
            }else{
                photoCell.selectBut.hidden = YES;
            }
        }
    }
    return photoCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //此处为单项点击 (selectType 选择，还是取消选择)
    [self judgeSelectTypeIsNo:NO indexItem:indexPath.item selectType:AddSelectRes];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------- 多选图片 delegate
- (void)selectSomeResourceIndexRowBut:(UIButton *)indexBut {
    NSInteger section = indexBut.tag - 666;
    self.isExpland[section] = [self.isExpland[section] isEqual:@0] ? @1 : @0;
    //查看数组中是否包含 @1， 包含则 有选中图片、则显示 '完成' ，不包含 则没有选中图片则显示 '取消'
    BOOL isBool = [self.isExpland containsObject:@1];
    if (isBool == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    /***************   选择时 取出选择数据   *****************/
    //此处为多项点击
    if (indexBut.selected == YES) {
        _addNum ++;
        //添加
        [self judgeSelectTypeIsNo:YES indexItem:section selectType:AddSelectRes];
    }else{
        //移除选择
        [self judgeSelectTypeIsNo:YES indexItem:section selectType:RemoveSelectRes];
        _addNum --;
    }
    /*
    if (_addNum > self.setMoreNum) {
        indexBut.enabled = NO;
    }else{
        indexBut.enabled = YES;
    }
     */
}
#pragma mark --- 判断 点击/选择 资源类型 (UIImage/NSData/Videos URL)
#pragma mark --- YES 为点击 多选 按钮， NO 单项点击
- (void)judgeSelectTypeIsNo:(BOOL)isNo indexItem:(NSInteger)item selectType:(MoreSelectType)selectType {
    PHAsset *asset = self.assetsModel.assets[item];
    NSString *titleStr = self.assetsModel.photoTitle;
    if ([titleStr isEqualToString:@"Videos"]) {
        [self enterVideosVcAsset:asset isNoMoreChoice:isNo videosType:selectType];
    }else if ([titleStr isEqualToString:@"视频"]){
        [self enterVideosVcAsset:asset isNoMoreChoice:isNo videosType:selectType];
    }else if ([titleStr isEqualToString:@"动图"]){
        [self enterGifVcAssets:asset isNoMoreChoice:isNo gifType:selectType];
    }else if ([titleStr isEqualToString:@"Animated"]){
        [self enterGifVcAssets:asset isNoMoreChoice:isNo gifType:selectType];
    }else{
        [self enterImageEditVcAsset:asset isNoMoreChoice:isNo imageType:selectType];
    }
}
#pragma MARK --- 跳转页
//视频 (isNoMoreChoice 是否为多选按钮，YES/NO 有不同操作. 单选点击直接返回资源数据 ，多项选择:多选之后点击 '完成'，返回所有点击资源)
- (void)enterVideosVcAsset:(PHAsset *)asset isNoMoreChoice:(BOOL)isNo videosType:(MoreSelectType)videosType {
    //如果为视频文件，则获取 url
//    __weak typeof(self)WeakSelf = self;
    PHVideoRequestOptions *videoRequestOptions = [[PHVideoRequestOptions alloc] init];
    videoRequestOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:videoRequestOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        if (asset && [asset isKindOfClass:[AVURLAsset class]] && [NSString stringWithFormat:@"%@", ((AVURLAsset *)asset).URL].length > 0) {
            //多项点击
            if (isNo == YES) {
                NSURL *url = ((AVURLAsset *)asset).URL;
                if (videosType == AddSelectRes) {
                    //设置多选最大数量
//                    if (self.addResArray.count < self.setMoreNum) {
//                    }
                    [self.addResArray addObject:url];
                }else if (videosType == RemoveSelectRes){
                    [self.addResArray removeObject:url];
                }
            }else{
                //单项点击
                if ([self.delegate respondsToSelector:@selector(selectVideosUrl:)]) {
                    [self.delegate selectVideosUrl:((AVURLAsset *)asset).URL];
                }
            }
        }
    }];
}
//gif (isNoMoreChoice 是否为多选按钮，YES/NO 有不同操作. 单选点击直接返回资源数据 ，多项选择:多选之后点击 '完成'，返回所有点击资源)
- (void)enterGifVcAssets:(PHAsset *)asset isNoMoreChoice:(BOOL)isNo gifType:(MoreSelectType)gifType{
    //动图 获取data
    NSData *data = [self.assetObj originalImageData:asset];
    //点击多选使用
    if (isNo == YES) {
        if (gifType == AddSelectRes) {
            //设置多选最大数量
//            if (self.addResArray.count < self.setMoreNum) {
//            }
            [self.addResArray addObject:data];
        }else if (gifType == RemoveSelectRes){
            [self.addResArray removeObject:data];
        }
    }else{
        //单项选择
        if ([self.delegate respondsToSelector:@selector(selectGifImageData:)]) {
            [self.delegate selectGifImageData:data];
        }
    }
}
//UIImage (isNoMoreChoice 是否为多选按钮，YES/NO 有不同操作.  单选点击直接返回资源数据 ，多项选择:多选之后点击 '完成'，返回所有点击资源)
- (void)enterImageEditVcAsset:(PHAsset *)asset isNoMoreChoice:(BOOL)isNo imageType:(MoreSelectType)imageType{
    //UIImage 图片
    UIImage *image;
    NSData *imageData;
    //返回原图
    if (self.isNoReturnOr == YES) {
        image = [self.assetObj originalImage:asset];
    } else {
        if (asset.pixelWidth > 100 || asset.pixelWidth <= 1000) {
            image = [self.assetObj smallImageSize:CGSizeMake(100, 100) asset:asset];
        }else{
            image = [self.assetObj originalImage:asset];
        }
        //多选是压缩后的图片，要是使用原图，可能NSData会很大，不便于操作
        imageData = UIImageJPEGRepresentation(image, 1);
    }
    //点击多选使用
    if (isNo == YES) {
        if (imageType == AddSelectRes) {
            //设置多选最大数量
//            if (self.addResArray.count < self.setMoreNum) {
//            }
            [self.addResArray addObject:imageData];
        }else if (imageType == RemoveSelectRes){
            [self.addResArray removeObject:imageData];
        }
    }else{
        //单选选择
        if ([self.delegate respondsToSelector:@selector(selectPhotoLibraryImage:)]) {
            [self.delegate selectPhotoLibraryImage:image];
        }
    }
}
#pragma mark ----------------------- 系统相册图片 ------------------------
//相册所有图片信息
- (void)getImages {
    AssetsHelper *imageAssets = [[AssetsHelper alloc] init];
    self.assetsModel.assets = [imageAssets getImageAssetsArray];
    
    for (NSInteger i = 0; i < self.assetsModel.assets.count; i++) {
        [self.isExpland addObject:@0];
    }
}
//图片信息
- (AlbumItem *)assetsModel {
    if (!_assetsModel) {
        _assetsModel = [[AlbumItem alloc] init];
    }
    return _assetsModel;
}
/** 资源对象 **/
- (WKWAsset *)assetObj {
    if (!_assetObj) {
        _assetObj = [[WKWAsset alloc] init];
    }
    return _assetObj;
}
//点击多选添加图片数组
- (NSMutableArray *)addResArray {
    if (!_addResArray) {
        _addResArray = [NSMutableArray array];
    }
    return _addResArray;
}
//用于判断是否选中
- (NSMutableArray *)isExpland {
    if (!_isExpland) {
        _isExpland = [NSMutableArray array];
    }
    return _isExpland;
}
//取消按钮方法
- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//选择多个图片/点击完成返回多选资源数据
- (void)finish {
    if (self.addResArray.count != 0) {
        if ([self.delegate respondsToSelector:@selector(moreSelectInfoArray:)]) {
            [self.delegate moreSelectInfoArray:self.addResArray];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击系统返回按钮方法
- (BOOL)navigationShouldPopOnBackButton {
    /* 点击系统返回按钮，返回相册集页，刷新相册集 */
    if ([self.delegate respondsToSelector:@selector(reloadLibraryCollention)]) {
        [self.delegate reloadLibraryCollention];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
