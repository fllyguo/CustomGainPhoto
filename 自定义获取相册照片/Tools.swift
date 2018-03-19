//
//  Tools.swift
//  TestSwift1
//
//  Created by 李美东 on 16/7/25.
//  Copyright © 2016年 李美东. All rights reserved.
//

import Foundation
import UIKit
    /**
     *   VFL自动布局，约束方法封装；
     *   水平或竖直约束使用
     */
     func GetNSLayoutCont(format:String,views:[String : UIView]) ->[NSLayoutConstraint]{
        let data = NSLayoutConstraint.constraints(withVisualFormat: format, options:  NSLayoutFormatOptions(), metrics: nil, views: views)
        
        return data
    }
    /**
     *VFL自动布局，左右居中或 上下居中使用；
     */
    func GetCenterConstraint(item:UIView,toItem:UIView,attribute:NSLayoutAttribute) ->NSLayoutConstraint
    {
   
        
      let constraint =   NSLayoutConstraint.init(item: item, attribute:attribute, relatedBy:NSLayoutRelation.equal, toItem:toItem, attribute:attribute, multiplier: 1.0, constant: 0.0)
        
        return constraint;
    }
    
    /*
     *此方法用于倒计时；
     *@pragramer time 倒计时时间；
     *@pragramer timeFinishHandle 闭包，用于处理倒计时结束时的操作；
     *@pragramer timeCountDownHandle 闭包，用于处理倒计时过程中得操作，同时把剩余时间传出；
     */
    func timeOutCount(time:Int, timeFinishHandle:@escaping ()->Void,timeCountDownHandle:@escaping (_ timeou:Int)->Void) {
        
        var timeout = time
        var timer : DispatchSourceTimer!
        let queue = DispatchQueue.global()
        timer = DispatchSource.makeTimerSource(queue: queue)
        let interval:DispatchTime = DispatchTime(uptimeNanoseconds: UInt64(timeout))
        timer.scheduleRepeating(deadline: interval, interval: .seconds(1))
        timer.setEventHandler(handler: { () ->Void in
            if timeout<=0
            {
                timer.cancel()
                timeFinishHandle()
            }
            else
            {
                timeCountDownHandle(timeout)
                timeout = timeout-1
            }
        })
        timer.resume()
    }
   /*
    *  取出本地化数据；
    */
func GetUserDefaults(key:String)-> Any
{
    let fault = UserDefaults.standard
    let value = fault.object(forKey: key)
    print("get：",key,value ?? "")
    return value ?? ""
}
/*
 *  数据本地化存储；
 */
func SaveLocalDataForUserDefault(key:String,value:Any) {
    let fault = UserDefaults.standard
    fault.set(value, forKey: key)
    print("save:",key,value)
    fault.synchronize()
}

