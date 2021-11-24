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
    @State private var shouldFilterPhotos = false
    
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
                
                photoFilter.padding()
                
                Spacer()
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
            shouldFilterPhotos = searchFilterData.shouldFilterPhotos
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
    
    @ViewBuilder
    var photoFilter: some View {
        ZStack {
            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: DrawingConstants.filterBorderLineWidth, dash: [DrawingConstants.filterBorderDash]))
            
            HStack {
                Text.regular(Labels.withPhoto)
                Spacer()
                
                ZStack {
                    if shouldFilterPhotos {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    } else {
                        Image(systemName: "circle").foregroundColor(.green)
                    }
                }
                .frame(CGSize(width: 50, height: 50 ))
                .buttonfity {
                    shouldFilterPhotos.toggle()
                }
            }.padding()
        }
        .foregroundColor(colorSet.textColor)
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
        searchFilterData.shouldFilterPhotos = false
    }
    
    private func apply() {
        searchFilterData.shouldFilterPhotos = shouldFilterPhotos
        searchFilterData.tags = selectedTags
        searchFilterData.folder = selectedFolder
    }
    
    struct DrawingConstants {
        static let tagInnerPadding: CGFloat = 8
        static let tagCornerRadius: CGFloat = 10
        static let folderInnerPadding: CGFloat = 8
        static let folderCornerRadius: CGFloat = 10
        static let filterBorderLineWidth: CGFloat = 2
        static let filterBorderDash: CGFloat = 10
        static let filterPadding: CGFloat = 20
    }
}

struct FilterScreen_Previews: PreviewProvider {
    static var previews: some View {
        FilterScreen()
    }
}
