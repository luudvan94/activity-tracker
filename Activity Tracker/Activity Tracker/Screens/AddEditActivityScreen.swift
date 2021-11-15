//
//  AddEditActivityScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout
import CoreData

struct AddEditActivityScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @ObservedObject var activity: Activity
    @Binding var showAddEditScreen: Bool
    
    var isAdding: Bool
    var colorSet: TimeColor.ColorSet {
        Helpers.colorByTime(time_)
    }
    @State private var showSelectTagsScreen = false
    @State private var showDateSelector = false
    @State private var time_: Date
    @State private var tags_: Set<Tag>
    @State private var note_: String
    @State private var errorMessage: String?
    
    init(activity: Activity, isAdding: Bool, colorSet: TimeColor.ColorSet, showAddEditScreen: Binding<Bool>) {
        _time_ = State(initialValue: activity.time)
        _tags_ = State(initialValue: activity.tags)
        _note_ = State(initialValue: activity.note == Labels.noNote ? "" : activity.note)
        self._showAddEditScreen = showAddEditScreen
        self.isAdding = isAdding
        self.activity = activity
    }
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    CancelDoneView(
                        onCancel: {
                            showAddEditScreen = false
                            
                        },
                        onDone: onTapDone
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
        .showError(shouldShow: errorMessage != nil, message: errorMessage ?? "", action: { errorMessage = nil })
        .sheet(isPresented: $showSelectTagsScreen) {
            SelectTagsScreen(selectedTags: $tags_, colorSet: colorSet)
        }
        .sheet(isPresented: $showDateSelector) {
            DatePickerView(currentDate: $time_, dateComponents: [.date, .hourAndMinute])
        }
        .onChange(of: time_) { _ in showDateSelector = false }
    }
    
    var title: some View {
        Text.header(isAdding ? Labels.new : Labels.edit)
            .foregroundColor(colorSet.textColor)
    }
    
    var timeSelector: some View {
        HStack {
            Text.regular(time_.weekDayMonthYearFormattedString + " " + time_.hourAndMinuteFormattedString).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "clock.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity(mainColor: .white, shadowColor: .shadow, action: { showDateSelector = true })
    }
    
    var tagSelector: some View {
        HStack {
            Text.regular(Labels.selectYourTags).foregroundColor(.black)
            
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
        let sortedTags = tags_.sorted { $0.name > $1.name }.map { $0.name }
        FlowLayout(mode: .scrollable, binding: $tags_, items: sortedTags) { tag in
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
                Text.regular(Labels.addViewPhoto).foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "photo.fill")
                    .foregroundColor(colorSet.main)
                    .font(.title2)
            }
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
            
            Text.regular(Labels.noPhoto).padding(.vertical)
        }
        .foregroundColor(colorSet.textColor)
    }
    
    var note: some View {
        ExpandingTextView(text: $note_, font: .body)
            .cornerRadius(20)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func onTapDone() {
        do {
            try Activity.save(activity: activity, with: (time_, tags_, note_), in: context)
            showAddEditScreen = false
        } catch let error as DataError {
            withAnimation {
                errorMessage = error.message
            }
        } catch {
            fatalError("Unknown error")
        }
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
        AddEditActivityScreen(activity: Activity(context: PersistenceController.preview.container.viewContext), isAdding: true, colorSet: TimeColor.noon.color, showAddEditScreen: .constant(true))
    }
}
