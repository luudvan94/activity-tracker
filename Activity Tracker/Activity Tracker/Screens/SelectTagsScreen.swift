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
    @State private var searchText = ""
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
                    searchBar
                    folderTagList
                    Spacer(minLength: 100)
                }
                .padding()
            }
            
            addNewTag.ignoresSafeArea()
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
        .fullScreenCover(isPresented: $showAddTagScreen) {
            AddTagScreen(colorSet: colorSet)
        }
    }
    
    var searchBar: some View {
        TextField("", text: $searchText)
            .modifier(TextFieldClearButton(text: $searchText))
            .placeholder(Labels.searchTag, when: searchText.isEmpty)
            .padding(.leading)
            .frame(height: DrawingConstants.searchBarHeight)
            .background(.white)
            .cornerRadius(DrawingConstants.searchBarCornerRadius)
    }
    
    @ViewBuilder
    var folderTagList: some View {
        VStack(alignment: .leading) {
            ForEach(folders) { folder in
                let filteredTags = folder.tags.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }
                if filteredTags.count > 0 {
                    constructFolderTagView(folderName: folder.name, tags: filteredTags)
                }
            }
        }
    }
    
    @ViewBuilder
    func constructFolderTagView(folderName: String, tags: Set<Tag>) -> some View {
        Text.regular(folderName).foregroundColor(colorSet.textColor).padding(.top)
        
        let sortedTags = tags.sorted { $0.name > $1.name  }
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
            .padding(.bottom)
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
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
        static let searchBarHeight: CGFloat = 50
        static let searchBarCornerRadius: CGFloat = 20.0
    }
}

struct SelectTagsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectTagsScreen(selectedTags: .constant(Set<Tag>()), colorSet: DayTime.sunset.colors)
    }
}
