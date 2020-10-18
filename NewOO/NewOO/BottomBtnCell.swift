//
//  BottomBtnCell.swift
//  OO
//
//  Created by 黄文汉 on 2020/10/10.
//

import UIKit

protocol BottomBtnCellClicked: NSObjectProtocol {
    func clicked(btn: UIButton)
}

class BottomBtnCell: UITableViewCell {
    
    @objc fileprivate func clickedBtn(btn: UIButton) {
        delegate?.clicked(btn: btn)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var btn: UIButton = {
        let temp = UIButton(title: "血糖记录表", fontSize: 48, color: UIColor.black, imageName: nil, backColor: nil)
        temp.addTarget(self, action: #selector(BottomBtnCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
        temp.backgroundColor = UIColor.cyan
        return temp
    }()
    weak var delegate: BottomBtnCellClicked?
}

extension BottomBtnCell {
    fileprivate func setupUI() {
        self.contentView.addSubview(btn)
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        btn.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}
