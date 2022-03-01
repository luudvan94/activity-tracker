//
//  CalendarAndDateSelectorView.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI

struct CalendarAndDateSelectorView: View {
    @Binding var selectedDate: Date
    var colorSet: DayTime.ColorSet
    
    var body: some View {
        HStack(alignment: .center) {
            calendar
            dateSelector
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(currentDate: $selectedDate)
        }
        .onChange(of: selectedDate) { _ in
            showDatePicker = false
        }
    }
    
    @State private var showDatePicker = false
    var calendar: some View {
        Image(systemName: "calendar")
            .foregroundColor(colorSet.main)
            .font(.title)
            .padding(8)
            .buttonfity(
                mainColor: .white,
                shadowColor: .shadow,
                action: { showDatePicker.toggle() })
            .frame(width: DrawingConstants.calendarWidth)
    }
    
    var dateSelector: some View {
        ZStack {
            Color.white.cornerRadius(DrawingConstants.daySelectorCornerRadius)
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DrawingConstants.spaceBetweenDays) {
                        ForEach(1 ... selectedDate.numberOfDaysInMonth, id: \.self) { day in
                            Text.regular("\(day)")
                                .padding(DrawingConstants.dayPadding)
                                .selectDay(day == selectedDate.day, hightlightColor: colorSet.main)
                                .foregroundColor(day == selectedDate.day ? colorSet.textColor : .black)
                                .onTapGesture {
                                    select(day, in: proxy)
                                }
                                .id(day)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: selectedDate) { [selectedDate] newDate in onDateChanged(previousDate: selectedDate, newDate: newDate, with: proxy) }
                .onAppear {
                    withAnimation {
                        proxy.scrollTo(selectedDate.day, anchor: .center)
                    }
                }
            }
        }
    }
    
    private func onDateChanged(previousDate: Date, newDate: Date, with proxy: ScrollViewProxy) {
        withAnimation {
            if newDate.month < previousDate.month {
                proxy.scrollTo(newDate.day)
            } else {
                proxy.scrollTo(newDate.day, anchor: .center)
            }
        }
    }
    
    private func select(_ day: Int, in scrollViewReader: ScrollViewProxy) {
        withAnimation {
            scrollViewReader.scrollTo(day, anchor: .center)
            selectedDate = Date.newDate(with: day, from: selectedDate)
        }
    }
    
    struct DrawingConstants {
        static let daySelectorCornerRadius: CGFloat = 20.0
        static let calendarWidth: CGFloat = 50
        static let spaceBetweenDays: CGFloat = 20
        static let dayPadding: CGFloat = 15
    }
}

struct CalendarAndDateSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarAndDateSelectorView(selectedDate: .constant(Date()), colorSet: DayTime.noon.colors)
    }
}
