//
//  AddTripScreen.swift
//  Activity Tracker
//
//  Created by luu van on 2/28/22.
//

import SwiftUI
import CoreData

struct AddTripScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    var colorSet: DayTime.ColorSet
    @Binding var showAddTripScreen: Bool
    
    @State private var time_ = Date()
    @State private var tripName_ = ""
    @State private var note_ = ""
    @State private var errorMessage: String?
    @State private var showDateSelector = false
    
    var body: some View {
        ZStack {
            colorSet.main.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    CancelDoneView(onCancel: { showAddTripScreen = false }, onDone: onTapDone).id(0).padding()
                    
                    title.id(1).padding()
                    
                    VStack(alignment: .leading, spacing: 40) {
                        timeSelector
                        tripName
                        note
                    }
                    .id(2)
                    .padding()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIWindow.keyboardDidShowNotification), perform: { _ in
                    withAnimation {
                        proxy.scrollTo(2, anchor: .bottom)
                    }
                })
            }
        }
        .showError(shouldShow: errorMessage != nil, message: errorMessage ?? "", action: { errorMessage = nil })
        .sheet(isPresented: $showDateSelector) {
            DatePickerView(currentDate: $time_, dateComponents: [.date, .hourAndMinute])
        }
    }
    
    var title: some View {
        Text.header(Labels.addNewTrip)
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
        .buttonfity {
            showDateSelector = true
        }
    }
    
    var tripName: some View {
        TextField("", text: $tripName_)
            .placeholder(Labels.tripName, when: tripName_.isEmpty)
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(DrawingConstants.textFieldCornderRadius)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    var note: some View {
        VStack(alignment: .leading) {
            Text.regular(Labels.note).foregroundColor(colorSet.textColor)
            ExpandingTextView(text: $note_, font: .body)
                .cornerRadius(20)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    private func onTapDone() {
        do {
            try Trip.save(trip: Trip(context: context), with: (time: time_, name: tripName_, note: note_), in: context)
            showAddTripScreen = false
        } catch let error as DataError {
            withAnimation {
                errorMessage = error.message
            }
        } catch {
            
        }
    }
    
    struct DrawingConstants {
        static let textFieldCornderRadius: CGFloat = 10
    }
}

struct AddTripScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTripScreen(colorSet: DayTime.sunset.colors, showAddTripScreen: .constant(false))
    }
}
