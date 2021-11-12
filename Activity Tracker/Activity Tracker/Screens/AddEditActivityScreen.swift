//
//  AddEditActivityScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout

struct AddEditActivityScreen: View {
    @State private var showSelectTagsScreen = false
    @ObservedObject var activity: Activity
    var isAdding: Bool
    var colorSet: TimeColor.ColorSet
    @Binding var showEditScreen: Bool
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    CancelDoneView(
                        onCancel: { showEditScreen = false },
                        onDone: {}
                    )
                    .padding()
                    
                    title
                    
                    timeSelector
                    
                    tagSelector
                    
                    selectedTags
                    
                    photoSelector
                    
                    note
                }
            }
        }
        .sheet(isPresented: $showSelectTagsScreen) {
            SelectTagsScreen(selectedTags: activity.tags, colorSet: colorSet)
        }
    }
    
    var title: some View {
        Text.header(isAdding ? "new activity" : "edit activity")
            .foregroundColor(colorSet.textColor)
    }
    
    var timeSelector: some View {
        HStack {
            Text.regular(activity.time.weekDayMonthYearFormattedString + " " + activity.time.hourAndMinuteFormattedString).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "clock.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
        .padding()
    }
    
    var tagSelector: some View {
        HStack {
            Text.regular("select tags for this activity").foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "tag.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
            showSelectTagsScreen = true
        })
        .padding()
    }
    
    @ViewBuilder
    var selectedTags: some View {
        let sortedTags = activity.tags.sorted { $0.name.count < $1.name.count }.map { $0.name }
        FlowLayout(mode: .scrollable, items: sortedTags) { tag in
            Text.regular(tag)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.tagCornerRadius)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var photoSelector: some View {
        VStack(alignment: .leading) {
            HStack {
                Text.regular("add or view photos").foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "photo.fill")
                    .foregroundColor(colorSet.main)
                    .font(.title2)
            }
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
            
            Text.regular("There is no photo for this activity").padding(.vertical)
        }
        .foregroundColor(colorSet.textColor)
        .padding()
    }
    
    var note: some View {
        TextEditor(text: $activity.note)
            .foregroundColor(.black)
            .cornerRadius(DrawingConstants.noteCornerRadius)
            .frame(minHeight: DrawingConstants.noteMinHeight)
            .padding()
    }
    
    struct DrawingConstants {
        static let cancelDoneButtonInnerPadding: CGFloat = 8
        static let noteCornerRadius: CGFloat = 20
        static let noteMinHeight: CGFloat = 100
        static let tagInnerPadding: CGFloat = 8
        static let tagCornerRadius: CGFloat = 10
    }
}

struct AddEditActivityScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddEditActivityScreen(activity: Activity(context: PersistenceController.preview.container.viewContext), isAdding: true, colorSet: TimeColor.noon.color, showEditScreen: .constant(true))
    }
}
