//
//  TabbarLayout.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/19.
//

import UIKit
struct Ratio {
    var ratio: CGFloat
}

final class TabbarLayout {
    var section: NSCollectionLayoutSection{
        let section = NSCollectionLayoutSection(group: customLayoutGroup)
        section.contentInsets = .init(top: padding, leading: 0, bottom: padding, trailing: 0)
        return section
    }
    
    //MARK: - Private methods
    
//    private let numberOfColumns: Int
    private let itemRatios: [Ratio]
    private let spacing: CGFloat
//    private let contentWidth: CGFloat
    private let contentHeight: CGFloat
    private let numberOfRows: Int
    private var padding: CGFloat {
        spacing / 2
    }
    
    // Padding around cells equal to the distance between cells
    private var insets: NSDirectionalEdgeInsets {
        return .init(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    private lazy var frames: [CGRect] = {
        calculateFrames()
    }()
    
    // Max height for section
    private lazy var sectionHeight: CGFloat = {
        (frames
            .map(\.maxY)
            .max() ?? 0
        ) + insets.bottom
    }()
    private lazy var sectionWidth: CGFloat = {
        (frames.map(\.maxX).max() ?? 0) + insets.trailing
        // 프래임들 중에 가장 큰 것을 찾아서 inset의 오른쪽과 더한다.
    }()
    
    private lazy var customLayoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(sectionWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        return NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
            self.frames.map { .init(frame: $0) }
        }
    }()
    
    init(rowCount:Int,itemRatios:[Ratio],spacing:CGFloat,contentHeight:CGFloat){
        self.numberOfRows = rowCount
        self.itemRatios = itemRatios
        self.spacing = spacing
        self.contentHeight = contentHeight
    }
     
    private func calculateFrames() -> [CGRect] {
        var contentWidth: CGFloat = 0
        let rowHeight = (contentHeight - insets.top - insets.bottom) / CGFloat(numberOfRows)
        
        var xOffset:[CGFloat] = .init(repeating: 0, count: numberOfRows)
        let yOffset = (0..<numberOfRows).map{CGFloat($0) * rowHeight}
        
        var currentRow = 0
        var frames = [CGRect]()
        
        for index in 0..<itemRatios.count {
            let aspectRatio = itemRatios[index]
            let frame = CGRect(x: xOffset[currentRow],y:yOffset[currentRow],width: rowHeight / aspectRatio.ratio,height: rowHeight)
            .insetBy(dx: padding, dy: padding)
            .offsetBy(dx: insets.top, dy: 0)
            .setHeight(ratio: aspectRatio.ratio)
            
            frames.append(frame)
        
            let rowLowestPoint = frame.maxX
            contentWidth = max(contentWidth,rowLowestPoint)
            xOffset[currentRow] = rowLowestPoint
            currentRow = xOffset.indexOfMinElement ?? 0
        }
        return frames
    }
}

private extension Array where Element: Comparable {
    
    var indexOfMinElement: Int? {
        guard count > 0 else { return nil }
        var min = first
        var index = 0
        
        indices.forEach { i in
            let currentItem = self[i]
            if let minumum = min, currentItem < minumum {
                min = currentItem
                index = i
            }
        }
        
        return index
    }
}

private extension CGRect {
    func setHeight(ratio: CGFloat) -> CGRect {
        .init(x: minX, y: minY, width: width, height: width / ratio)
    }
}
