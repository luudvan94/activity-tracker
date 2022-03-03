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
    @State private var shouldFilterLocation = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView() {
                
                title.padding()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        tagSelector
                        selectedTagsView
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        folderSelector
                        selectedFolderView
                    }.padding()
                    
                    VStack(alignment: .leading) {
                        filterText
                        photoFilter
                        locationFilter
                    }.padding()
                }
                
                Spacer(minLength: 100)
            }
            
            toolsBar
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
            shouldFilterLocation = searchFilterData.shouldFilterLocation
        }
    }
    
    var colorSet: DayTime.ColorSet {
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
    
    var photoFilter: some View {
        FeatureFilterView(colorSet: colorSet, iconName: "photo.fill", title: Labels.withPhoto, isSelected: shouldFilterPhotos) {
            shouldFilterPhotos.toggle()
        }
    }
    
    var locationFilter: some View {
        FeatureFilterView(colorSet: colorSet, iconName: "map.fill", title: Labels.withLocationTracking, isSelected: shouldFilterLocation) {
            shouldFilterLocation.toggle()
        }
    }
    
    var filterText: some View {
        Text.header(Labels.otherFilters).foregroundColor(colorSet.textColor)
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
        Text.regular(Labels.apply).foregroundColor(.blue).padding().buttonfity {
            withAnimation {
                apply()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    @ViewBuilder
    var toolsBar: some View {
        ZStack {
            HStack {
                HStack {
                    clearButton
                    
                    Spacer()
                    
                    applyButton
                }
            }
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
        .padding(.horizontal)
    }
    
    private func clear() {
        searchFilterData.tags = []
        searchFilterData.folder = nil
        searchFilterData.shouldFilterPhotos = false
        searchFilterData.shouldFilterLocation = false
    }
    
    private func apply() {
        searchFilterData.shouldFilterPhotos = shouldFilterPhotos
        searchFilterData.tags = selectedTags
        searchFilterData.folder = selectedFolder
        searchFilterData.shouldFilterLocation = shouldFilterLocation
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
