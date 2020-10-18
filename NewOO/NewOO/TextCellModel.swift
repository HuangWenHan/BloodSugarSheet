//
//  TextCellModel.swift
//  NewOO
//
//  Created by 黄文汉 on 2020/10/19.
//

import UIKit


class TextCellModel: NSObject {
    
    var bloodSugerContentStr: String?
    
    var bloodSugerCellIdentifier: Int?

    
    init(dict: [String: Any]) {
        super.init()
        self.bloodSugerContentStr  = dict["bloodSugerContentStr"] as? String
        self.bloodSugerCellIdentifier = dict["bloodSugerCellIdentifier"] as? Int
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
