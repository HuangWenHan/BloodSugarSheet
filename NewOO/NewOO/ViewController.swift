//
//  ViewController.swift
//  NewOO
//
//  Created by 黄文汉 on 2020/10/18.
//
import UIKit
import IQKeyboardManagerSwift

class ViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"
    
    enum Section {
        case main
    }

    //var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var textCellTextfiledTextAndIdentifierDataSource: [TextCellModel] = {
        var temp: [TextCellModel] = []
        for i in 0..<350 {
            var model: TextCellModel = TextCellModel(dict: ["bloodSugerContentStr" : ""])
            //model.bloodSugerContentStr = "----"
            model.bloodSugerCellIdentifier = i
            temp.append(model)
        }
        return temp
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

extension ViewController {
    /// - Tag: Grid
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: ViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.dayLabel.text = "第\( (identifier) % 7 + 1)天"
            cell.model = self.textCellTextfiledTextAndIdentifierDataSource[identifier]
            cell.bloodSugarTextfiled.text = self.textCellTextfiledTextAndIdentifierDataSource[identifier].bloodSugerContentStr
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
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }

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

extension ViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        IQKeyboardManager.shared.resignFirstResponder()
//    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        IQKeyboardManager.shared.resignFirstResponder()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension ViewController: TTextCellTextFiledDidEndEditing {
    func textCellTextFiledDidEndEditing(textFiledText: String, currentCellIdentifier: Int) {
        self.textCellTextfiledTextAndIdentifierDataSource[currentCellIdentifier].bloodSugerContentStr = textFiledText
    }
}
