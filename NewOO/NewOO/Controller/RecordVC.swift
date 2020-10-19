//
//  RecordVC.swift
//  NewOO
//
//  Created by 黄文汉 on 2020/10/19.
//

import UIKit
import IQKeyboardManagerSwift
import Charts
class RecordVC: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var textCellTextfiledTextArrayUsingIdentifier: [String] = {
        
        guard let myDefaults: [String] = UserDefaults.standard.value(forKey: "textCellTextfiledTextArrayUsingIdentifier") as? [String] else {
            var temp: [String] = []
            for i in 0..<350 {
                temp.append("")
            }
            UserDefaults.standard.setValue(temp, forKey: "textCellTextfiledTextArrayUsingIdentifier")
            return temp
        }
        return myDefaults
    }()
    
    
    
    var collectionView: UICollectionView! = nil
    var conditionArray: Array = ["早饭前", "早饭后", "午饭前", "午饭后", "晚饭前", "晚饭后", "睡前"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grid"
        configureHierarchy()
        configureDataSource()
        view.backgroundColor = UIColor.red
        
    }
}

extension RecordVC {
    /// - Tag: Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(1 / 3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(20))
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(200))
        //let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),heightDimension: .fractionalWidth(1 / 3))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: RecordVC.sectionHeaderElementKind, alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: RecordVC.sectionFooterElementKind, alignment: .bottom)
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension RecordVC {
    private func configureHierarchy() {
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: createLayout())
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.dayLabel.text = "第\( (identifier) % 7 + 1)天"
            cell.cellIdentifier = identifier
            cell.bloodSugarTextfiled.text = self.textCellTextfiledTextArrayUsingIdentifier[identifier]
            //cell.model = self.textCellTextfiledTextAndIdentifierDataSource[identifier]
            //cell.bloodSugarTextfiled.text = self.textCellTextfiledTextAndIdentifierDataSource[identifier].bloodSugerContentStr
            
            cell.delegate = self
            cell.conditionLabel.text = self.conditionArray[(identifier % 7)]
            cell.contentView.backgroundColor = UIColor.orange
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1

            // 在这里给cell赋值 就不会有重用问题
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Header") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "第\(indexPath.section + 1)周:"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: "Footer") {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "FOOTER"
            let chartView: LineChartView = LineChartView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200))
            chartView.backgroundColor = UIColor.purple
            

            
            
            
            let xAxis = chartView.xAxis
            xAxis.labelPosition = .topInside
            xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
            xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = true
            xAxis.centerAxisLabelsEnabled = true
            xAxis.granularity = 3600
            xAxis.valueFormatter = DateValueFormatter()
            
            let leftAxis = chartView.leftAxis
            leftAxis.labelPosition = .insideChart
            leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
            leftAxis.drawGridLinesEnabled = true
            leftAxis.granularityEnabled = true
            leftAxis.axisMinimum = 0
            leftAxis.axisMaximum = 170
            leftAxis.yOffset = -9
            leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)

            
            chartView.rightAxis.enabled = false
            chartView.legend.form = .line
            chartView.animate(xAxisDuration: 2.5)
            
            
            
            let now = Date().timeIntervalSince1970
            let hourSeconds: TimeInterval = 3600
            
            let from = now - (Double(7) / 2) * hourSeconds
            let to = now + (Double(7) / 2) * hourSeconds
            
            let values = stride(from: from, to: to, by: hourSeconds).map { (x) -> ChartDataEntry in
                let y = arc4random_uniform(7) + 50
                return ChartDataEntry(x: x, y: Double(y))
            }
            
            let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
            set1.axisDependency = .left
            set1.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
            set1.lineWidth = 1.5
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = false
            set1.fillAlpha = 0.26
            set1.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSet: set1)
            data.setValueTextColor(.white)
            data.setValueFont(.systemFont(ofSize: 9, weight: .light))
            
            chartView.data = data
            
            
            
            
            supplementaryView.addSubview(chartView)
            
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
//        dataSource.supplementaryViewProvider = { (view, kind, index) in
//            print(index)
//            return self.collectionView.dequeueConfiguredReusableSupplementary(
//                using: kind == RecordVC.sectionHeaderElementKind ? headerRegistration : footerRegistration, for: index)
//        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            
            
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind == RecordVC.sectionHeaderElementKind ? headerRegistration : footerRegistration, for: index)
        }
       
//        dataSource.supplementaryViewProvider = { (view, kind, index) in
//            print(index)
//            return self.collectionView.dequeueConfiguredReusableSupplementary(
//                using: footerRegistration, for: index)
//        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0
        let itemsPerSection = 7
        for section in 0..<50 {
            snapshot.appendSections([section])
            let maxIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
}

//import UIKit
//
//class ViewController: UIViewController {
//
//    enum Section {
//        case main
//        case content
//    }
//
//    var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
//    var contentDataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
//    var collectionView: UICollectionView! = nil
//    var contentCollectionView: UICollectionView! = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "Grid"
//        configureHierarchy()
//        configureDataSource()
//    }
//}
//
//extension ViewController {
//    /// - Tag: Grid
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                             heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .fractionalWidth(1.0))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
//                                                         subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//    private func createContentLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                             heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .fractionalWidth(1.0))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                         subitems: [item])
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//}
//
//extension ViewController {
//    private func configureHierarchy() {
//        //collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width / 5, height: UIScreen.main.bounds.size.height), collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .black
//
//        contentCollectionView = UICollectionView(frame: CGRect(x: UIScreen.main.bounds.size.width / 5, y: 0, width: UIScreen.main.bounds.size.width * 0.8, height: UIScreen.main.bounds.size.height), collectionViewLayout: createContentLayout())
//        contentCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentCollectionView.backgroundColor = .red
//
//        view.addSubview(collectionView)
//        view.addSubview(contentCollectionView)
//    }
//    private func configureDataSource() {
//
//        if #available(iOS 14.0, *) {
//            let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
//                // Populate the cell with our item description.
//                if identifier == 0 {
//                    cell.label.text = ""
//                } else {
//                    cell.label.text = "第\(identifier)周"
//                }
//
//                cell.contentView.backgroundColor = UIColor.orange
//                cell.layer.borderColor = UIColor.blue.cgColor
//                cell.layer.borderWidth = 1
//                cell.label.textAlignment = .center
//                cell.label.font = UIFont.preferredFont(forTextStyle: .subheadline)
//            }
//
//            dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
//                (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
//                // Return the cell.
//                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//            }
//            contentDataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: contentCollectionView) {
//                (contentCollectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
//                // Return the cell.
//                return contentCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//            }
//
//            // initial data
//            var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
//            snapshot.appendSections([.main])
//            snapshot.appendItems(Array(0..<48))
//            dataSource.apply(snapshot, animatingDifferences: false)
//
//            var contentSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
//            contentSnapshot.appendSections([.content])
//            contentSnapshot.appendItems(Array(0..<48))
//            contentDataSource.apply(contentSnapshot, animatingDifferences: false)
//        } else {
//            dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {collectionView, indexPath, identifier in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(identifier)", for: indexPath) as! TextCell
//                    collectionView.register(TextCell.self, forCellWithReuseIdentifier: "\(identifier)")
//                    cell.label.text = "\(identifier)13"
//                    cell.contentView.backgroundColor = UIColor.red
//                    cell.layer.borderColor = UIColor.black.cgColor
//                    cell.layer.borderWidth = 1
//                    cell.label.textAlignment = .center
//                    cell.label.font = UIFont.preferredFont(forTextStyle: .subheadline)
//                    return cell
//                }
//            var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
//            snapshot.appendSections([.main])
//            snapshot.appendItems(Array(0..<94))
//            dataSource.apply(snapshot, animatingDifferences: false)
//        }
//    }
//}

extension RecordVC: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //IQKeyboardManager.shared.resignFirstResponder()
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension RecordVC: TTextCellTextFiledDidEndEditing {
    func textCellTextFiledDidEndEditing(textFiledText: String, cellIdentifier: Int) {
        self.textCellTextfiledTextArrayUsingIdentifier[cellIdentifier] = textFiledText
        UserDefaults.standard.setValue(self.textCellTextfiledTextArrayUsingIdentifier, forKey: "textCellTextfiledTextArrayUsingIdentifier")
    }
}
