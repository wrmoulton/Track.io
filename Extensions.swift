//
//  Extensions.swift
//  Track.io
//
//  Created by William on 12/18/23.
//

import Foundation
import SwiftUI
extension Color {
    static let backgrounds = Color("Background")
    static let icons = Color("Icon")
    static let texts = Color("Text")
    static let systemBackground = Color(uiColor: .systemBackground)
}
extension DateFormatter{
    static let allNumericUSA: DateFormatter = {
        print("Initializing Date Formatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}
extension String{
    func dateParse()-> Date {
        guard let parsedDate = DateFormatter.allNumericUSA.date(from: self)else {return Date()}
        return parsedDate
    }
}
