//
//  Date+Ext.swift
//  StoreData
//
//  Created by Ditha Nurcahya Avianty on 07/01/23.
//

import Foundation

extension Date {
    func formatTodMMMyyyy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-M-yyyy"
        return dateFormatter.string(from: self)
    }
}
