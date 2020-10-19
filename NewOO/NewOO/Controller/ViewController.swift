//
//  ViewController.swift
//  NewOO
//
//  Created by 黄文汉 on 2020/10/18.
//
import UIKit
import SnapKit

private let ContentLabelCellID = "ContentLabelCellID"
private let BottomBtnCellID = "BottomBtnCellID"

class ViewController: UIViewController {

    
    
    override func loadView() {
        super.loadView()
        setupUI()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        self.navigationItem.title = "注意事项"
        
    }

    fileprivate lazy var tabView: UITableView = UITableView()
    fileprivate lazy var contentLabelArray: Array = ["饮食: 要求定时定量 (每天6或7两主食)", "早餐: 1两馒头或米饭，1个鸡蛋，1杯牛奶;", "午餐: 2两半或3两馒头或米饭，青菜随意吃;", "晚餐: 2两半或3两馒头或米饭，青菜随意吃;", "运动: 三餐后快步走，早,中每次20-30分钟，晚上40-60分钟", "其他注意事项: 戒烟酒，不喝粥，不吃甜食,水果和零食(包括无糖食品)，蔬菜无限制，糖尿病肾病患者不吃豆制品。"]
}

extension ViewController {
    fileprivate func setupUI() {
        self.view.addSubview(tabView)
        for v in self.view.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
//        topLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.view)
//            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
//        }
        tabView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        prepareTabView()
    }
    fileprivate func prepareTabView() {
        self.tabView.delegate = self
        self.tabView.dataSource = self
        self.tabView.showsVerticalScrollIndicator = false
        //self.tabView.separatorStyle = .none
        self.tabView.tableFooterView = UIView()
        self.tabView.backgroundColor = UIColor.white
        tabView.register(ContentLabelCell.self, forCellReuseIdentifier: ContentLabelCellID)
        tabView.register(BottomBtnCell.self, forCellReuseIdentifier: BottomBtnCellID)
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentLabelArray.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 6 {
            let cell = BottomBtnCell()
            cell.delegate = self
            return cell
        } else {
            let cell = tabView.dequeueReusableCell(withIdentifier: ContentLabelCellID, for: indexPath) as! ContentLabelCell
            cell.backgroundColor = UIColor.white
            cell.contentLabel.text = contentLabelArray[indexPath.row]
            return cell
        }
    }
}

extension ViewController: BottomBtnCellClicked {
    func clicked(btn: UIButton) {
        self.navigationController?.pushViewController(RecordVC(), animated: true)
    }
}
