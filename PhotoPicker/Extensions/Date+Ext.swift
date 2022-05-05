//
//  Date+Ext.swift
//  PhotoPicker
//
//  Created by Nodirbek on 05/05/22.
//

import Foundation

extension Date {
    
    func convertMonthYearFormat()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
    
}
