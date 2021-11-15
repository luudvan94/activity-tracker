//
//  DatePickerView.swift
//  DayTracker
//
//  Created by Luu Van on 7/8/21.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var currentDate: Date
    var dateComponents: DatePickerComponents = [.date]
    
    var body: some View {
        ZStack {
            DatePicker("", selection: $currentDate, displayedComponents: dateComponents)
                .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(currentDate: .constant(Date()))
    }
}
