/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Generic text cell
*/

import UIKit
import SnapKit

protocol TTextCellTextFiledDidEndEditing: NSObjectProtocol {
    //func textCellTextFiledDidEndEditing(textFiledText: String, currentCellIdentifier: Int)
    func textCellTextFiledDidEndEditing(textFiledText: String, cellIdentifier: Int)
    func textCellTextFiledFinallyDidEndEditing()
}

protocol TTextCellTextFiledShouldBeginEditing: NSObjectProtocol {
    //func textCellTextFiledDidEndEditing(textFiledText: String, currentCellIdentifier: Int)
    func textCellTextFiledShouldBeginEditing(currentTextFieldRect: CGRect)
}

protocol doneClickedProtocol: NSObjectProtocol {
    //func textCellTextFiledDidEndEditing(textFiledText: String, currentCellIdentifier: Int)
    func doneclicked(btn: UIButton)
}

class TextCell: UICollectionViewCell {
    let label = UILabel()
    static let reuseIdentifier = "text-cell-reuse-identifier"
    

    @objc func clickedBtn(btn: UIButton) {
        self.bloodSugarTextfiled.resignFirstResponder()
        delegate3?.doneclicked(btn: btn)
    }
    weak var delegate: TTextCellTextFiledDidEndEditing?
    weak var delegate2: TTextCellTextFiledShouldBeginEditing?
    weak var delegate3: doneClickedProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configure()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    lazy var dayLabel: UILabel = UILabel(title: "第N天", fontSize: 22, color: UIColor.black, redundance: 0)
    lazy var conditionLabel: UILabel = UILabel(title: "早饭前", fontSize: 22, color: UIColor.black, redundance: 0)
    lazy var bloodSugarLabel: UILabel = UILabel(title: "血糖值:", fontSize: 20, color: UIColor.black, redundance: 0)
    lazy var bloodSugarTextfiled: UITextField = {
        let temp = UITextField()
        temp.placeholder = "-----"
        temp.keyboardType = .decimalPad
        temp.addDoneOnKeyboardWithTarget(self, action: #selector(TextCell.clickedBtn(btn:)))

        temp.keyboardToolbar.doneBarButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.5)], for: .normal)
        temp.layer.borderWidth = 1
        temp.layer.borderColor = UIColor.red.cgColor
        temp.contentHorizontalAlignment = .center
        temp.contentVerticalAlignment = .center
        temp.font = UIFont.systemFont(ofSize: 20)
        temp.delegate = self
        return temp
    }()
//    fileprivate lazy var confirmBtn: UIButton = {
//        let temp = UIButton(title: "锁定", fontSize: 22, color: .black, imageName: nil)
//        temp.addTarget(self, action: #selector(TextCell.clickedBtn(btn:)), for: UIControl.Event.touchUpInside)
//        return temp
//    }()
    
    var cellIdentifier: Int?
    
}

extension TextCell {
    func setupUI() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(bloodSugarLabel)
        contentView.addSubview(bloodSugarTextfiled)
        //contentView.addSubview(confirmBtn)
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        dayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(12)
        }
        conditionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(dayLabel.snp.bottom).offset(12)
        }
        bloodSugarLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView).offset(-25)
            make.top.equalTo(conditionLabel.snp.bottom).offset(12)
        }
        bloodSugarTextfiled.snp.makeConstraints { (make) in
            make.centerY.equalTo(bloodSugarLabel)
            make.left.equalTo(bloodSugarLabel.snp.right).offset(5)
        }
//        confirmBtn.snp.makeConstraints { (make) in
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(bloodSugarTextfiled.snp.bottom).offset(12)
//        }
    }
    
}

extension TextCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textCellTextFiledDidEndEditing(textFiledText: textField.text!, cellIdentifier: cellIdentifier!)
        delegate?.textCellTextFiledFinallyDidEndEditing()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        print(textField.text!)
        delegate?.textCellTextFiledDidEndEditing(textFiledText: textField.text!, cellIdentifier: cellIdentifier!)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        let window = UIApplication.shared.keyWindow
        let rect = self.bloodSugarTextfiled.convert(self.bloodSugarTextfiled.bounds, from: window)
        print(rect)
        delegate2?.textCellTextFiledShouldBeginEditing(currentTextFieldRect: rect)
        return true
    }
}




extension TextCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}
