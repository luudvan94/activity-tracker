//
//  SelectFolderScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct SelectFolderScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedFolder: Folder?
    var colorSet: DayTime.ColorSet
    
    @FetchRequest(entity: Folder.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Folder.name_, ascending: true)]) var folders: FetchedResults<Folder>
    
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
        Text.header(Labels.folders).foregroundColor(colorSet.textColor)
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
                presentationMode.wrappedValue.dismiss()
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
        SelectFolderScreen(selectedFolder: .constant(nil), colorSet: DayTime.sunset.colors)
    }
}
