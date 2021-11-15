//
//  SelectTagsScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI

struct SelectTagsScreen: View {
    @Binding var selectedTags: Set<Tag>
    @State private var showAddTagScreen = false
    var colorSet = TimeColor.noon.color
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name_, ascending: true)]) var folders: FetchedResults<Folder>
    
    init(selectedTags: Binding<Set<Tag>>, colorSet: TimeColor.ColorSet) {
        self._selectedTags = selectedTags
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
                .padding()
            }
        }
        .fullScreenCover(isPresented: $showAddTagScreen) {
            AddTagScreen(colorSet: colorSet, showAddTagScreen: $showAddTagScreen)
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
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                showAddTagScreen = true
            })
    }
    
    var folderTagList: some View {
        VStack(alignment: .leading) {
            ForEach(folders) { folder in
                folderWithTagView(folder: folder)
                
            }
        }
    }
    
    @ViewBuilder
    func folderWithTagView(folder: Folder) -> some View {
        Text.regular(folder.name).foregroundColor(colorSet.textColor).padding(.top)
        
        let sortedTags = folder.tags.sorted { $0.name > $1.name  }
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
        SelectTagsScreen(selectedTags: .constant(Set<Tag>()), colorSet: TimeColor.sunset.color)
    }
}
