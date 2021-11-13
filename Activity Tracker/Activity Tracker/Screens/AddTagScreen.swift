//
//  AddTagScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI

struct AddTagScreen: View {
    var colorSet: TimeColor.ColorSet
    @Binding var showAddTagScreen: Bool
    
    @State private var tagName_ = ""
    @State private var folderName_ = ""
    @State private var selectedFolder: Folder?
    @State private var showSelectFolderScreen = false
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                CancelDoneView(onCancel: { showAddTagScreen = false }, onDone: {}).padding()
                
                title
                VStack(alignment: .leading, spacing: 40) {
                    tagName
                    VStack(alignment: .leading) {
                        folderNameText
                        folderName
                        or
                        folderSelector
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showSelectFolderScreen) {
            SelectFolderScreen(selectedFolder: selectedFolder, colorSet: colorSet)
        }
    }
    
    var title: some View {
        Text.header("new tag")
            .foregroundColor(colorSet.textColor)
    }
    
    var tagName: some View {
        TextField("tag name...", text: $tagName_).padding().background(.white).cornerRadius(DrawingConstants.textFieldCornderRadius)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var folderNameText: some View {
        Text.regular("you can create new folder for this tag").foregroundColor(colorSet.textColor)
    }
    
    var folderName: some View {
        TextField("folder name...", text: $folderName_).padding().background(.white).cornerRadius(DrawingConstants.textFieldCornderRadius)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var or: some View {
        Text.regular("or").foregroundColor(colorSet.textColor)
    }
    
    var folderSelector: some View {
        Text.regular("select from existing folders")
            .foregroundColor(.black)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                showSelectFolderScreen = true
            })
    }
    
    struct DrawingConstants {
        static let textFieldCornderRadius: CGFloat = 10
    }
}

struct AddTagScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTagScreen(colorSet: TimeColor.night.color, showAddTagScreen: .constant(true))
    }
}
