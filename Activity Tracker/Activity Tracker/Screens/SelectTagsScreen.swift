//
//  SelectTagsScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct SelectTagsScreen: View {
    @State private var selectedTags = Set<Tag>()
    var colorSet = TimeColor.noon.color
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name_, ascending: true)]) var folders: FetchedResults<Folder>
    
    init(selectedTags: Set<Tag>, colorSet: TimeColor.ColorSet) {
        _selectedTags = State(initialValue: selectedTags)
        self.colorSet = colorSet
    }
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    
                    addNewTag
                    
                    folderTagList
                }
            }
        }
    }
    
    var title: some View {
        Text.header("tags").foregroundColor(colorSet.textColor)
    }
    
    var addNewTag: some View {
        Text("add new tag")
            .foregroundColor(.black)
            .padding(.vertical, DrawingConstants.addNewTagInnerVerticalPadding)
            .padding(.horizontal, DrawingConstants.addNewTagInnerHorizontalPadding)
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
    }
    
    var folderTagList: some View {
        VStack(alignment: .leading) {
            ForEach(folders) { folder in
                folderWithTagView(folder: folder)
                
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func folderWithTagView(folder: Folder) -> some View {
        Text.regular(folder.name).foregroundColor(colorSet.textColor).padding(.top)
        
        let sortedTags = folder.tags.sorted { $0.name.count < $1.name.count }
        FlowLayout(mode: .scrollable, items: sortedTags) { tag in
            HStack {
                Text(tag.name).foregroundColor(.black)
                
                Image(systemName: "circle.fill")
                    .font(.footnote)
                    .foregroundColor(selectedTags.contains(tag) ? colorSet.main : .white)
            }
            .padding(DrawingConstants.tagInnerPadding)
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                select(tag)
            })
            .padding(.trailing, DrawingConstants.tagTrailingPadding)
            .padding(.vertical, DrawingConstants.tagVerticalPadding)
        }
    }
    
    func select(_ tag: Tag) {
        if !selectedTags.contains(tag) {
            selectedTags.insert(tag)
        } else {
            selectedTags.remove(tag)
        }
    }
    
    struct DrawingConstants {
        static let addNewTagInnerVerticalPadding: CGFloat = 5
        static let addNewTagInnerHorizontalPadding: CGFloat = 20
        static let tagInnerPadding: CGFloat = 8
        static let tagTrailingPadding: CGFloat = 2
        static let tagVerticalPadding: CGFloat = 5
    }
}

struct SelectTagsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectTagsScreen(selectedTags: Set<Tag>(), colorSet: TimeColor.sunset.color)
    }
}
