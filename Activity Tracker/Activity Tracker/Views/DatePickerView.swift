//
//  DatePickerView.swift
//  DayTracker
//
//  Created by Luu Van on 7/8/21.
//

import SwiftUI

struct DatePickerView: View {
  @Binding var currentDate: Date

  var body: some View {
    ZStack {
      Color.white
      DatePicker("", selection: $currentDate, displayedComponents: [.date])
        .datePickerStyle(GraphicalDatePickerStyle())
    }
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerView(currentDate: .constant(Date()))
  }
}
