//
//  TableViewCell.swift
//  TestAllPhoto
//
//  Created by 徐翔 on 2017/3/16.
//  Copyright © 2017年 李美东. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var imgView:UIImageView?
    
    var title:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        
        if imgView == nil {
            imgView = UIImageView()
            imgView?.contentMode = .scaleAspectFill
            imgView?.translatesAutoresizingMaskIntoConstraints = false
            imgView?.clipsToBounds = true
            self.contentView.addSubview(imgView!)
            
        }
        if title == nil {
            title = UILabel()
            title?.font = UIFont.systemFont(ofSize: 16)
            title?.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(title!)
            
        }
        
        
        self.contentView.addConstraints(GetNSLayoutCont(format: "H:|-[imgView(80)]-[title]-|", views: ["imgView":imgView!, "title":title!]))
        self.contentView.addConstraints(GetNSLayoutCont(format: "V:[imgView(80)]", views: ["imgView":imgView!]))
        self.contentView.addConstraints(GetNSLayoutCont(format: "V:[title(20)]", views: ["title":title!]))
        
        self.contentView.addConstraint(NSLayoutConstraint.init(item: imgView!, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: title!, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
