//
//  TopTabViewer.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/18.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import RxDataSources
class TopTabViewer: UICollectionView{
    let tabIndex = BehaviorSubject(value: 0)
    let subject:BehaviorSubject<[TopTabSection]> =  BehaviorSubject(value: [])
    var disposeBag = DisposeBag()
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    lazy var rxDataSource = RxCollectionViewSectionedReloadDataSource<TopTabSection> {  dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell",
                                                                                     for: indexPath) as? TopTabCell else {return .init()}
        cell.data = item
        return cell
    }
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: Self.layout)
        self.showsHorizontalScrollIndicator = false
        self.register(TopTabCell.self, forCellWithReuseIdentifier: "BasicCell")
        Observable.combineLatest(subject,tabIndex).map { (sections,idx) in
            guard var section = sections.first else {return []}
            var topItems = section.items.map{
                var item = $0
                item.isSelected = false
                return item
            }
            topItems[idx].isSelected = true
            section.items = topItems
            return [section]
        }.bind(to: self.rx.items(dataSource: rxDataSource))
            .disposed(by: disposeBag)
        rx.itemSelected.map{$0.row }.bind(to: tabIndex).disposed(by: disposeBag)
        tabIndex
            .subscribe(on: MainScheduler.asyncInstance)
            .bind { [weak self] val in
                UIView.animate(withDuration: 0.3) {
                    self?.scrollToItem(at: IndexPath(row: val, section: 0), at: .centeredHorizontally, animated: false)
                }
        }.disposed(by: disposeBag)
    }
}
extension TopTabViewer{
    fileprivate static var layout:UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        
        layoutConfig.scrollDirection = .horizontal
        layout.configuration = layoutConfig
        return layout
    }
}
struct TopTabSection {
    var header: String
    var items: [TopTabItem]
    init(header: String, items: [TopTabItem]) {
        self.header = header
        self.items = items
    }
}
extension TopTabSection: SectionModelType {
    init(original: TopTabSection, items: [TopTabItem]) {
        self = original
        self.items = items
    }
}
struct TopTabItem:Identifiable,Hashable{
    var id:String {name}
    var name:String
    var isSelected:Bool
}
final class TopTabCell: UICollectionViewCell{
    var data:TopTabItem?{
        didSet{
            guard let data else {return}
            label.text = data.name
            self.underView.isHidden = !data.isSelected
            self.underView.alpha = 0
            label.textColor = .systemGray
            underView.backgroundColor = .systemGray
            UIView.animate(withDuration: 0.15) {
                if data.isSelected{
                    self.label.textColor = .text
                    self.underView.backgroundColor = .text
                    self.underView.alpha = 1
                }
            }
            
        }
    }
    let label = UILabel()
    let underView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = .systemFont(ofSize: 18,weight: .semibold)
        self.contentView.addSubview(label)
        self.contentView.addSubview(underView)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        underView.backgroundColor = .systemBlue
        underView.snp.makeConstraints { make in
            make.height.equalTo(4)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(2)
        }
        underView.layer.cornerRadius = 2
        underView.layer.cornerCurve = .circular
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
