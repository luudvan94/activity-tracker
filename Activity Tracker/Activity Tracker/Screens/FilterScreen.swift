//
//  FilterScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/23/21.
//

import SwiftUI

struct FilterScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var searchFilterData: SearchFilterData
    @EnvironmentObject var appSetting: AppSetting
    
    @State private var showSelectTagsScreen = false
    @State private var showSelectFolderScreen = false
    @State private var selectedTags: Set<Tag> = []
    @State private var selectedFolder: Folder? = nil
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                
                title.padding()
                
                VStack(alignment: .leading) {
                    tagSelector
                    selectedTagsView
                }
                .padding()
                
                VStack(alignment: .leading) {
                    folderSelector
                    selectedFolderView
                }.padding()
                
                Spacer()
                HStack(spacing: 40) {
                    clearButton
                    applyButton
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSelectTagsScreen) {
            SelectTagsScreen(selectedTags: $selectedTags, colorSet: appSetting.colorSet, enableAddNewTag: false)
        }
        .sheet(isPresented: $showSelectFolderScreen) {
            SelectFolderScreen(selectedFolder: $selectedFolder, colorSet: appSetting.colorSet)
        }
        .onAppear {
            selectedTags = searchFilterData.tags
            selectedFolder = searchFilterData.folder
        }
    }
    
    var colorSet: TimeColor.ColorSet {
        appSetting.colorSet
    }
    
    var title: some View {
        Text.header(Labels.filters).foregroundColor(colorSet.textColor)
    }
    
    var tagSelector: some View {
        HStack {
            Text.regular(Labels.filterByTags).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "tag.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity {
            showSelectTagsScreen = true
        }
    }
    
    @ViewBuilder
    var selectedTagsView: some View {
        let sortedTags = selectedTags.sorted { $0.name > $1.name }.map { $0.name }
        FlowLayout(mode: .scrollable, binding: $selectedTags, items: sortedTags) { tag in
            Text.regular(tag)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.tagCornerRadius)
        }
    }
    
    var folderSelector: some View {
        HStack {
            Text.regular(Labels.filterByFolders).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "folder.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity {
            showSelectFolderScreen = true
        }
    }
    
    @ViewBuilder
    var selectedFolderView: some View {
        if let folder = selectedFolder {
            Text.regular(folder.name)
                .foregroundColor(.black)
                .padding(DrawingConstants.folderInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.folderCornerRadius)
                .padding(.top)
        } else {
            EmptyView()
        }
    }
    
    var clearButton: some View {
        Text.regular(Labels.clearFilter).foregroundColor(.black).padding().buttonfity {
            withAnimation {
                clear()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var applyButton: some View {
        Text.regular(Labels.apply).foregroundColor(.black).padding().buttonfity {
            withAnimation {
                apply()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func clear() {
        searchFilterData.tags = []
        searchFilterData.folder = nil
    }
    
    private func apply() {
        searchFilterData.tags = selectedTags
        searchFilterData.folder = selectedFolder
    }
    
    struct DrawingConstants {
        static let tagInnerPadding: CGFloat = 8
        static let tagCornerRadius: CGFloat = 10
        static let folderInnerPadding: CGFloat = 8
        static let folderCornerRadius: CGFloat = 10
    }
}

struct FilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
    }
}
