//
//  NewCollectionViewController.swift
//  TestAllPhoto
//
//  Created by 李美东 on 2017/3/15.
//  Copyright © 2017年 李美东. All rights reserved.
//

import UIKit
import Photos

class NewCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var collection : UICollectionView!
    
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    var selectImage:selectPictureBlock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //如果没有传入值，则获取所有资源
        if assetsFetchResults == nil {
            //获取所有资源
            let allPhotosOptions = PHFetchOptions()
            //按照创建时间倒序排列
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                 ascending: false)]
            //只获取图片
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                     PHAssetMediaType.image.rawValue)
            assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                     options: allPhotosOptions)
        }
        
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        self.initUserInfoUI(size: CGSize(width: 100, height: 100))
        
        
    }
    
    func initUserInfoUI(size:CGSize)
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = size
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DesignViewCell")
        self.view.addSubview(collection)
        
        let viewDic = ["collection":collection] as [String : UIView]
        
        self.view.addConstraints(GetNSLayoutCont(format: "H:|[collection]|", views: viewDic))
        self.view.addConstraints(GetNSLayoutCont(format: "V:|[collection]|", views: viewDic))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.main.scale
        let cellSize = (collection.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale ,
                                        height:cellSize.height*scale)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    // CollectionView行数
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // 获取单元格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "DesignViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath)) as UICollectionViewCell
        
        let asset = self.assetsFetchResults[indexPath.row]
        //获取缩略图
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,contentMode: PHImageContentMode.aspectFill,
                                       options: nil) { (image, nfo) in
                                        
                                        let sds = UIImageView(image: image)
                                        cell.backgroundView = sds
        }
        return cell
    }
    
    // 单元格点击响应
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        let myAsset = self.assetsFetchResults[indexPath.row]
            let phImageRequestOptions = PHImageRequestOptions()
            phImageRequestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: myAsset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: phImageRequestOptions) { (image, info) in
                print(image as Any)
            if image != nil {
                self.selectImage(image!)
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
