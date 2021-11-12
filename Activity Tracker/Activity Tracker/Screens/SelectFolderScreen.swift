//
//  SelectFolderScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct SelectFolderScreen: View {
    @State private var selectedFolder: Folder?
    var colorSet: TimeColor.ColorSet
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name_, ascending: true)]) var folders: FetchedResults<Folder>
    
    init(selectedFolder: Folder?, colorSet: TimeColor.ColorSet) {
        _selectedFolder = State(initialValue: selectedFolder)
        self.colorSet = colorSet
    }
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    foldersList
                }
                .padding()
            }
        }
    }
    
    var title: some View {
        Text.header("folders").foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    var foldersList: some View {
        let sortedFolders = folders.sorted { $0.name.count < $1.name.count }
        FlowLayout(mode: .scrollable, items: sortedFolders) { folder in
            HStack {
                Text(folder.name).foregroundColor(.black)
                
                Image(systemName: "circle.fill")
                    .font(.footnote)
                    .foregroundColor(selectedFolder == folder ? colorSet.main : .white)
            }
            .padding(DrawingConstants.folderInnerPadding)
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                select(folder)
            })
            .padding(.trailing, DrawingConstants.folderTrailingPadding)
            .padding(.vertical, DrawingConstants.folderVerticalPadding)
        }
    }
    
    private func select(_ folder: Folder) {
        selectedFolder = folder
    }
    
    struct DrawingConstants {
        static let folderInnerPadding: CGFloat = 8
        static let folderTrailingPadding: CGFloat = 2
        static let folderVerticalPadding: CGFloat = 5
    }
}

struct SelectFolderScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectFolderScreen(selectedFolder: nil, colorSet: TimeColor.sunset.color)
    }
}
