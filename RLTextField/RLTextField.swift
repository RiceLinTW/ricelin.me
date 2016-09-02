//
//  RLTextField+ReturnedNumberPad.swift
//  MyStaff
//
//  Created by RiceLin on 2/16/16.
//  Copyright © 2016 Rice. All rights reserved.
//

import UIKit

enum RLTextFieldType : Int {
    case String     = 0
    case Int        = 1
    case Phone      = 2
    case Email      = 3
    case Url        = 4
    case Picker     = 5
    case Date       = 6
    case Password   = 7
}

class RLTextField: UITextField {
    
    var type    : RLTextFieldType?
    var key     : String?
    
    var picker              : UIPickerView?     = nil
    var pickerTextSeparator : String            = " "
    var choice              : [[AnyObject]]     = []
    var relativeComponets   : Bool              = false
    
    var datePicker          : UIDatePicker      = UIDatePicker()
    var dateFormatter       : NSDateFormatter   = NSDateFormatter()
    var toolbar             : UIToolbar         = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
    
    convenience init(settings : RLTextFieldSettings) {
        self.init()
        datePicker.datePickerMode = settings.datePickerMode!
        datePicker.timeZone = NSTimeZone(forSecondsFromGMT: 8 * 3600)
        datePicker.calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        datePicker.locale = NSLocale(localeIdentifier: "zh_Hant")
        if settings.datePickerStartDate != nil {
            datePicker.date = settings.datePickerStartDate!
        } else {
            datePicker.date = NSDate().dateByAddingTimeInterval(-18 * 365.25 * 24 * 60 * 60)
        }
        datePicker.addTarget(self, action: #selector(RLTextField.dateChanged), forControlEvents: .ValueChanged)
        
        // TODO: - dateformatter
        if settings.dateFormat == nil {
            switch datePicker.datePickerMode {
            case .CountDownTimer:
                dateFormatter.dateFormat = "HH:mm"
                break
            case .Date:
                dateFormatter.dateFormat = "yyyy/MM/dd"
                break
            case .DateAndTime:
                dateFormatter.dateFormat = "yyyy/MM/dd EEEE HH:mm"
                break
            case .Time:
                dateFormatter.dateFormat = "HH:mm"
                break
            }
        } else {
            dateFormatter.dateFormat = settings.dateFormat
        }
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 8 * 3600)
        dateFormatter.calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        picker = UIPickerView()
        if settings.pickerTextSeparator != nil {
            pickerTextSeparator = settings.pickerTextSeparator!
        }
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(UIResponder.resignFirstResponder))
        toolbar.items = [space, doneButton]
        toolbar.sizeToFit()
        
        if settings.choice != nil {
            choice = settings.choice!
        }
        self.relativeComponets = settings.relativeComponets
        
        self.type = RLTextFieldType(rawValue: (settings.type?.rawValue)!)
        self.key = settings.key
        switch self.type! {
        case .String :
            keyboardType = .Default
            break
        case .Int :
            keyboardType = .NumberPad
            inputAccessoryView = toolbar
            break
        case .Phone :
            keyboardType = .PhonePad
            inputAccessoryView = toolbar
            break
        case .Email :
            keyboardType = .EmailAddress
            break
        case .Url :
            keyboardType = .URL
            inputAccessoryView = toolbar
        case .Picker :
            inputView = picker
            inputAccessoryView = toolbar
            break
        case .Date:
            inputView = datePicker
            inputAccessoryView = toolbar
            break
        case .Password:
            keyboardType = .Default
            break
        }
        self.placeholder = settings.placeholder
    }
    
    func dateChanged() {
        text = dateFormatter.stringFromDate(datePicker.date)
    }
    
}

public class RLTextFieldSettings {
    
    var type                : RLTextFieldType?
    var key                 : String            = ""

    var placeholder         : String?
    
    var choice              : [[AnyObject]]?
    var relativeComponets   : Bool              = false
    var pickerTextSeparator : String?
    var datePickerMode      : UIDatePickerMode? = .Date
    var dateFormat          : String?
    var datePickerStartDate : NSDate?
    
    convenience init(StringTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .String
        self.key = key
        self.placeholder = placeholder
    }
    
    convenience init(IntTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .Int
        self.key = key
        self.placeholder = placeholder
    }
    
    convenience init(PhoneTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .Phone
        self.key = key
        self.placeholder = placeholder
    }
    
    convenience init(EmailTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .Email
        self.key = key
        self.placeholder = placeholder
    }
    
    convenience init(UrlTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .Url
        self.key = key
        self.placeholder = placeholder
    }
    
    convenience init(PickerTypeKey key : String, choice : [[AnyObject]], relativeComponets : Bool, placeholder : String?, separator : String?) {
        self.init()
        self.type = .Picker
        self.key = key
        self.placeholder = placeholder
        
        self.choice = choice
        self.relativeComponets = relativeComponets
        self.placeholder = placeholder
        self.pickerTextSeparator = separator
    }
    
    convenience init(DateTypeKey key : String, placeholder : String?, mode : UIDatePickerMode, dateFormat : String?, startDate: NSDate) {
        self.init()
        self.type = .Date
        self.key = key
        self.placeholder = placeholder
        self.datePickerMode = mode
        self.datePickerStartDate = startDate
        self.dateFormat = dateFormat
    }
    
    convenience init(PasswordTypeKey key : String, placeholder : String) {
        self.init()
        self.type = .Password
        self.key = key
        self.placeholder = placeholder
    }
}