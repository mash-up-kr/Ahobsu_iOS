//
//  DateField.swift
//  Ahobsu
//
//  Created by JU HO YOON on 2020/01/28.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

struct DateField: UIViewRepresentable {

    typealias UIViewType = UITextField

    @Binding var dateString: String

    var textFieldDelegator: UITextFieldDelegate = ReadOnlyTextFieldDelegate()
    var datePickerHandler: DatePickerHandler = DatePickerHandler()

    func makeUIView(context: UIViewRepresentableContext<DateField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        textField.textColor = .rosegold
        textField.delegate = textFieldDelegator
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.addTarget(datePickerHandler,
                             action: #selector(self.datePickerHandler.didChangeDatePickerValue),
                             for: .valueChanged)
        datePickerHandler.didChangeDate = { newDate in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = .withFullDate
            self.dateString = formatter.string(from: newDate)
            textField.resignFirstResponder()
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                textField.alpha = 1
            }
            animator.startAnimation()
        }
        textField.inputView = datePicker
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<DateField>) {
        UIView.animate(withDuration: 1) {
            uiView.text = self.dateString
        }
    }
}

extension DateField {

    class DatePickerHandler: NSObject {

        var didChangeDate: ((Date) -> Void)?

        @objc func didChangeDatePickerValue(sender: UIDatePicker) {
            didChangeDate?(sender.date)
        }
    }
}

extension DateField {

    class ReadOnlyTextFieldDelegate: NSObject, UITextFieldDelegate {

        func textFieldDidBeginEditing(_ textField: UITextField) {
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                textField.alpha = 0.5
            }
            animator.startAnimation()
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeOut) {
                textField.alpha = 1
            }
            animator.startAnimation()
        }

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            return false
        }
    }
}
