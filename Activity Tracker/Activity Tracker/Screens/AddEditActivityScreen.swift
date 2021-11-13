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
            
            ScrollViewReader { proxy in
                ScrollView {
                    CancelDoneView(
                        onCancel: { showEditScreen = false },
                        onDone: {}
                    ).id(0)
                    .padding()
                    
                    VStack(spacing: DrawingConstants.defaultSpacing) {
                        title
                        timeSelector
                        VStack {
                            tagSelector.padding(.vertical)
                            selectedTags
                        }
                        photoSelector
                        
                        note
                    }
                    .id(1)
                    .padding()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIWindow.keyboardDidShowNotification), perform: { _ in
                    withAnimation {
                        proxy.scrollTo(1, anchor: .bottom)
                    }
                })
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
    }
    
    @ViewBuilder
    var selectedTags: some View {
        let sortedTags = activity.tags.sorted { $0.name > $1.name }.map { $0.name }
        FlowLayout(mode: .scrollable, items: sortedTags) { tag in
            Text.regular(tag)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.tagCornerRadius)
        }
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
    }
    
    var note: some View {
        ExpandingTextView(text: $activity.note, font: .body)
            .cornerRadius(20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    struct DrawingConstants {
        static let cancelDoneButtonInnerPadding: CGFloat = 8
        static let noteCornerRadius: CGFloat = 20
        static let noteMinHeight: CGFloat = 100
        static let tagInnerPadding: CGFloat = 8
        static let tagCornerRadius: CGFloat = 10
        static let defaultSpacing: CGFloat = 30
    }
}

struct AddEditActivityScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddEditActivityScreen(activity: Activity(context: PersistenceController.preview.container.viewContext), isAdding: true, colorSet: TimeColor.noon.color, showEditScreen: .constant(true))
    }
}
