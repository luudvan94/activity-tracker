//
//  SelectTagsScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI

struct SelectTagsScreen: View {
    @Binding var selectedTags: Set<Tag>
    var colorSet = DayTime.noon.colors
    var enableAddNewTag: Bool
    
    @State private var showAddTagScreen = false
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name_, ascending: true)]) var folders: FetchedResults<Folder>
    
    init(selectedTags: Binding<Set<Tag>>, colorSet: DayTime.ColorSet, enableAddNewTag: Bool = true) {
        self._selectedTags = selectedTags
        self.colorSet = colorSet
        self.enableAddNewTag = enableAddNewTag
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    folderTagList
                    Spacer(minLength: 100)
                }
                .padding()
            }
            
            addNewTag
        }
        .fullScreenCover(isPresented: $showAddTagScreen) {
            AddTagScreen(colorSet: colorSet, showAddTagScreen: $showAddTagScreen)
        }
    }
    
    var title: some View {
        Text.header(Labels.tags).foregroundColor(colorSet.textColor)
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
    
    @ViewBuilder
    var addNewTag: some View {
        ZStack {
            HStack {
                Text.regular(Labels.addNewTag).foregroundColor(.black).padding().buttonfity {
                    showAddTagScreen = true
                }
                
                Spacer()
            }
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
        .padding(.horizontal)
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
        SelectTagsScreen(selectedTags: .constant(Set<Tag>()), colorSet: DayTime.sunset.colors)
    }
}
