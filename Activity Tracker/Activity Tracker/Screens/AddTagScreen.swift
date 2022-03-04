//
//  AddTagScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import CoreData

struct AddTagScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    var colorSet: DayTime.ColorSet
    
    @State private var tagName_ = ""
    @State private var folderName_ = ""
    @State private var selectedFolder: Set<Folder> = []
    @State private var showSelectFolderScreen = false
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                CancelDoneView(
                    onCancel: { presentationMode.wrappedValue.dismiss() },
                    onDone: onTapDone,
                    colorSet: colorSet
                ).padding()
                
                title
                VStack(alignment: .leading, spacing: 40) {
                    tagName
                    VStack(alignment: .leading) {
                        folderNameText
                        folderName
                        or
                        folderSelector
                        folderSelecting
                    }
                }
                .padding()
            }
        }
        .showError(shouldShow: errorMessage != nil, message: errorMessage ?? "", action: { errorMessage = nil })
        .sheet(isPresented: $showSelectFolderScreen) {
            SelectFolderScreen(colorSet: colorSet, selectedFolders: $selectedFolder) { folder in
                selectedFolder = [folder]
            }
        }
        .onChange(of: selectedFolder, perform: { _ in showSelectFolderScreen = false })
    }
    
    var title: some View {
        Text.header(Labels.newTag)
            .foregroundColor(colorSet.textColor)
    }
    
    var tagName: some View {
        TextField("", text: $tagName_)
            .placeholder(Labels.tagName, when: tagName_.isEmpty)
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(DrawingConstants.textFieldCornderRadius)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var folderNameText: some View {
        Text.regular(Labels.createFolder).foregroundColor(colorSet.textColor)
    }
    
    var folderName: some View {
        TextField("", text: $folderName_)
            .placeholder(Labels.folderName, when: folderName_.isEmpty)
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(DrawingConstants.textFieldCornderRadius)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var or: some View {
        Text.regular("or").foregroundColor(colorSet.textColor)
    }
    
    var folderSelector: some View {
        Text.regular(Labels.selectFolder)
            .foregroundColor(.black)
            .padding()
            .buttonfity {
                showSelectFolderScreen = true
            }
    }
    
    @ViewBuilder
    var folderSelecting: some View {
        if let folder = selectedFolder.first {
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
    
    private func onTapDone() {
        do {
            if let folder = selectedFolder.first {
                try Tag.save(tag: Tag(context: context), with: (tagName: tagName_, folder: folder), in: context)
            } else {
                try Tag.save(tag: Tag(context: context), with: (tagName: tagName_, folderName: folderName_), in: context)
            }
            
            presentationMode.wrappedValue.dismiss()
        } catch let error as DataError {
            withAnimation {
                errorMessage = error.message
            }
        } catch {
            
        }
    }
    
    struct DrawingConstants {
        static let textFieldCornderRadius: CGFloat = 10
        static let folderInnerPadding: CGFloat = 8
        static let folderCornerRadius: CGFloat = 10
    }
}

struct AddTagScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTagScreen(colorSet: DayTime.night.colors)
    }
}
