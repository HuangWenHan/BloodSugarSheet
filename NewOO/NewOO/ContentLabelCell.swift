//
//  ContentLabelCell.swift
//  OO
//
//  Created by 黄文汉 on 2020/10/9.
//

import UIKit

class ContentLabelCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var contentLabel: UILabel = UILabel(title: "", fontSize: 30, color: UIColor.black, redundance: 40)
}

extension ContentLabelCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(contentLabel)
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        contentLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(self.contentView).offset(20)
        }
    }
}
