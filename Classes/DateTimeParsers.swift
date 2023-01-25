//
//  GPXDateTime.swift
//  CoreGPX
//
//  Created on 23/3/19.
//
//  Original code from: http://jordansmith.io/performant-date-parsing/
//  Modified to better suit CoreGPX's functionalities.
//

import Foundation


/**
 Date Parser for use when parsing GPX files, containing elements with date attributions.
 
 It can parse ISO8601 formatted date strings, along with year strings to native `Date` types.
 
 Formerly Named: `ISO8601DateParser` & `CopyrightYearParser`
 */
final class GPXDateParser {

    private let year = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    
    deinit {
        year.deallocate()
    }
    
    // MARK:- String To Date Parsers
    
    /// Parses an ISO8601 formatted date string as native Date type.
    func parse(date string: String?) -> Date? {
        guard let NonNilString = string else {
            return nil
        }
      
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: NonNilString) {
          return date
        }
        
        formatter.formatOptions =  [.withInternetDateTime]
        return formatter.date(from: NonNilString)
    }
    
    /// Parses a year string as native Date type.
    func parse(year string: String?) -> Date? {
        guard let NonNilString = string else {
            return nil
        }
        
        _ = withVaList([year], { pointer in
            vsscanf(NonNilString, "%d", pointer)
        })

        return DateComponents(year: year.pointee).date
    }
}
