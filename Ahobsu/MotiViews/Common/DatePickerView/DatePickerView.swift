//
//  DDPicker.swift
//  Ahobsu
//
//  Created by JU HO YOON on 2020/02/19.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

struct DatePickerView: View {
    
    @ObservedObject var dateManager: DateManager
    
    @State var years: [Int] = (1900...Calendar.current.component(.year, from: Date())).map { $0 }
    @State var months: [Int] = (1...12).map { $0 }
    @State var days: [Int] = (1...31).map { $0 }
    
    init(selection: Binding<Date>) {
        dateManager = DateManager(date: selection)
    }
    
    var body: some View {
        HStack {
            WheelView(selectedItem: $dateManager.year, items: years)
                .frame(width: 72, height: 44 * 3)
            WheelView(selectedItem: $dateManager.month, items: months)
                .frame(width: 72, height: 44 * 3)
            WheelView(selectedItem: $dateManager.day, items: days)
                .frame(width: 72, height: 44 * 3)
        }
        .frame(maxWidth: .infinity, minHeight: 158)
    }
}

struct DDPicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(selection: .constant(Date()))
    }
}
