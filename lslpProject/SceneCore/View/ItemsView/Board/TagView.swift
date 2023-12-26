//
//  TagView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import SwiftUI

struct Tag: Identifiable,Hashable{
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = .zero
}

struct TagView: View {
    var maxLimit: Int
    @Binding var tags: [Tag]
    let fontSize:CGFloat = 14
    var body: some View {
        VStack(alignment:.leading,spacing:10){
            ForEach(getRows(),id:\.self){ rows in
                HStack(spacing:6){
                    ForEach(rows){ row in
                        // Row View...
                        RowView(tag: row)
                    }
                }
            }
        }
        .frame(width: UIScreen.current!.bounds.width - 80,alignment:.leading)
        .padding(.vertical,8)
        .onChange(of: tags) { oldValue, newValue in
            guard let last = tags.last else {return}
            let font = UIFont.systemFont(ofSize: fontSize)
            let attributes = [NSAttributedString.Key.font:font]
            let size = (last.text as NSString).size(withAttributes: attributes)
            
            tags[getIndex(tag: last)].size = size.width
        }
        .animation(.easeInOut,value: tags)
    }
    
    @ViewBuilder
    func RowView(tag:Tag) -> some View{
        HStack(spacing:4){
            Text(tag.text)
                .font(.system(size: fontSize,weight: .semibold))
                .lineLimit(1)
            Image(systemName: "xmark.circle").imageScale(.small)
        }.padding(.horizontal,14)
            .padding(.vertical,8)
            .background(
                Capsule().fill(.regularMaterial)
            )
            .contentShape(Capsule())
            .wrapBtn {
                tags.remove(at: getIndex(tag: tag))
            }
    }
    
    func getIndex(tag:Tag) -> Int{
        return tags.firstIndex { currentTag in
            tag.id == currentTag.id
        } ?? 0
    }
    // 배열에서 스크린 사이즈를 넘어가면 다음 배열로 넘기기
    func getRows()->[[Tag]]{
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        // 텍스트 너비 계산
        var totalWidth: CGFloat = 0
        
        var screenWidth: CGFloat = UIScreen.current!.bounds.width - 90
        tags.forEach { tag in
            // 한 줄 너비 더하기
            // 14 + 14 + 6 + 6
            totalWidth += (tag.size + 40 + 10)
            // 스크린 너비 넘어가나 확인
            if totalWidth > screenWidth{
                //                한 태그가 한 줄을 전부 차지하는 경우
                totalWidth = (!currentRow.isEmpty ? (tag.size + 40 + 4 + 6) : 0)
                rows.append(currentRow)
                currentRow.removeAll()
            }
            currentRow.append(tag)
        }
        if !currentRow.isEmpty{
            rows.append(currentRow)
        }
        return rows
    }
}

//#Preview {
//    TagView()
//}
