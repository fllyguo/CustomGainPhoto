//
//  PhotoLibraryListViewController.swift
//  TestAllPhoto
//
//  Created by 徐翔 on 2017/3/16.
//  Copyright © 2017年 李美东. All rights reserved.
//

import UIKit
import Photos

typealias selectPictureBlock = (UIImage)->Void
//相簿列表项
class AlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>

    init(title:String?,fetchResult:PHFetchResult<PHAsset>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

class PhotoLibraryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //相簿列表项集合
    var items:[AlbumItem] = []
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    
    var tableView:UITableView?
    
    var isFirstLoad:Bool = true
    
    var selectImage:selectPictureBlock!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.title = "照片"
        //申请权限
        weak var W_self = self
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                let alert = UIAlertController(title: "提示", message: "APP没有获取相册权限,去打开相册访问权限。", preferredStyle: .alert)
                let deleteAction = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                    //引到打开相册权限
                    let url = NSURL.init(string: UIApplicationOpenSettingsURLString)! as URL
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.openURL(url)
                    }
                })
                alert.addAction(deleteAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async{
                if W_self?.isFirstLoad != nil && (W_self?.isFirstLoad)! {
                    let co = NewCollectionViewController()
                    co.title = "相机胶卷"
                    co.selectImage = {
                        (image:UIImage)->Void in
                        if W_self?.selectImage != nil {
                            W_self?.selectImage(image)
                        }
                    }
                    W_self?.navigationController?.pushViewController(co, animated: false)
                }
            }
           
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                      subtype: .albumRegular,
                                                                      options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            //列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections
                as! PHFetchResult<PHAssetCollection>)
            
            //相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            //异步加载表格数据,需要在主线程中调用reloadData() 方法
            DispatchQueue.main.async{
                self.imageManager = PHCachingImageManager()
                self.resetCachedAssets()
                self.tableView?.reloadData()
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    private func setupUI() {
        if tableView == nil {
            tableView = UITableView.init(frame: CGRect.zero, style: .plain)
            tableView?.translatesAutoresizingMaskIntoConstraints = false
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.tableFooterView = UIView()
            tableView?.rowHeight = 100;
            if #available(iOS 9.0, *) {
                tableView?.cellLayoutMarginsFollowReadableWidth = false
            } else {
                
            }
            self.view.addSubview(tableView!)
            
            self.view.addConstraints(GetNSLayoutCont(format: "H:|[tableView]|", views: ["tableView":tableView!]))
            self.view.addConstraints(GetNSLayoutCont(format: "V:|[tableView]|", views: ["tableView":tableView!]))
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancel))
        
        
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }

    
    //转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            // 不是照片的相簿不显示；
             let title = titleOfAlbumForChinse(title: c.localizedTitle)
            if title=="Slo-mo" || title=="慢动作" || title=="Time-lapse" || title=="延时摄影" || title=="Videos" || title=="视频" || title=="Panoramas" || title=="全景照片" || title=="Hidden" || title=="已隐藏" || title=="Depth Effect" || title=="景深效果"{
                continue
            }
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                items.append(AlbumItem(title: title,
                                       fetchResult: assetsFetchResult))
            }
        }
        
    }
    
    //由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(title:String?) -> String? {
         if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        }  else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
         }else if title == "Recently Deleted" {
            return "最近删除"
        }
         else if title == "Depth Effect" {
            return "景深效果"
        }
        return title
    }
    
    //表格分区数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //表格单元格数量
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //设置单元格内容
    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "myCell"
        //同一形式的单元格重复使用，在声明时已注册
        var cell = tableView.dequeueReusableCell(withIdentifier: identify) as? TableViewCell
        if cell == nil {
            cell = TableViewCell.init(style: .subtitle, reuseIdentifier: identify)
        }
        let item = self.items[indexPath.row]
        cell?.title?.text = item.title! + "(\(item.fetchResult.count))"
        
        // 初始化和重置缓存
       
        if item.fetchResult.count>0 {
            if self.imageManager != nil {
                self.imageManager.requestImage(for: item.fetchResult.lastObject!, targetSize: CGSize.init(width: 80*UIScreen.main.scale, height: 80*UIScreen.main.scale),
                                               contentMode: PHImageContentMode.aspectFill,
                                               options: nil) { (image, info) in
                                                cell?.imgView?.image = image
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.row]
        let co = NewCollectionViewController()
        co.assetsFetchResults = item.fetchResult
        co.title = item.title
        co.selectImage = {
            (image:UIImage)->Void in
            if self.selectImage != nil {
                self.selectImage(image)
            }
        }
        self.navigationController?.pushViewController(co, animated: true)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
