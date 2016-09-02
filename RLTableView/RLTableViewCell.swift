//
//  NewStaffCell.swift
//  MyStaff
//
//  Created by RiceLin on 2/15/16.
//  Copyright © 2016 Rice. All rights reserved.
//

import UIKit

extension RLTextField {
    
    convenience init(textFieldData : RLRow) {
        self.init()
        datePicker.datePickerMode = textFieldData.datePickerMode!
        datePicker.timeZone = NSTimeZone(forSecondsFromGMT: 8 * 3600)
        datePicker.calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        datePicker.locale = NSLocale(localeIdentifier: "zh_Hant")
        if textFieldData.datePickerStartDate != nil {
            datePicker.date = textFieldData.datePickerStartDate!
        } else {
            datePicker.date = NSDate().dateByAddingTimeInterval(-18 * 365.25 * 24 * 60 * 60)
        }
        datePicker.addTarget(self, action: #selector(RLTextField.dateChanged), forControlEvents: .ValueChanged)
        
        // TODO: - dateformatter
        if textFieldData.dateFormat == nil {
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
            dateFormatter.dateFormat = textFieldData.dateFormat
        }
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 8 * 3600)
        dateFormatter.calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        picker = UIPickerView()
        if textFieldData.pickerTextSeparator != nil {
            pickerTextSeparator = textFieldData.pickerTextSeparator!
        }
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(UIResponder.resignFirstResponder))
        toolbar.items = [space, doneButton]
        toolbar.sizeToFit()
        
        if textFieldData.choice != nil {
            choice = textFieldData.choice!
        }
        self.relativeComponets = textFieldData.relativeComponets
        
        self.type = RLTextFieldType(rawValue: (textFieldData.type?.rawValue)!)
        self.key = textFieldData.key
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
        self.placeholder = textFieldData.placeholder
    }
}

enum RLTableViewCellType : Int {
    case String     = 0
    case Int        = 1
    case Phone      = 2
    case Email      = 3
    case Url        = 4
    case Picker     = 5
    case Date       = 6
    case Password   = 7
    case Switch     = 8
    case Check      = 9
}

class RLTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var cellData    : RLRow?
    var cellType    : RLTableViewCellType?

    var cellTitle   : UILabel?
    var cellContent : RLTextField?
    var checkBox    : UIButton?
    var cellSwitch  : UISwitch?
    
    var rowHeight   : CGFloat = 50
    
    convenience init(cellData : RLRow, rowHeight : CGFloat) {
        self.init()
        self.cellData = cellData
        self.cellType = cellData.type
        self.rowHeight = rowHeight
        setCell(cellData)
    }

    func setCell(data : RLRow) {
        cellTitle?.textColor = UIColor.blackColor()
        
        if self.cellType == .Check {
            checkBox = UIButton(type: .Custom)
            checkBox?.frame = CGRectMake(0, 0, 30, 30)
            checkBox?.center = CGPointMake(25, rowHeight / 2)
            checkBox?.setImage(UIImage(named: data.uncheckedImageName!), forState: .Normal)
            checkBox?.setImage(UIImage(named: data.checkedImageName!), forState: .Selected)
            self.addSubview(checkBox!)
            
            cellTitle = UILabel(frame: CGRectMake(45, 0, UIScreen.mainScreen().bounds.width - 50 - 30, rowHeight))
            cellTitle?.adjustsFontSizeToFitWidth = true
            cellTitle?.textAlignment = .Left
            cellTitle?.text = data.title
            cellTitle?.numberOfLines = 2
            self.addSubview(cellTitle!)
            if data.detail!{
                accessoryType = .DisclosureIndicator
            }
        } else if self.cellType == .Switch {
            cellTitle = UILabel(frame: CGRectMake(10, 0, 105, rowHeight))
            cellTitle?.adjustsFontSizeToFitWidth = true
            cellTitle?.text = data.title
            self.addSubview(cellTitle!)

            cellSwitch = UISwitch()
            cellSwitch!.on = data.switchOn!
            cellSwitch?.center = CGPointMake(UIScreen.mainScreen().bounds.width - (cellSwitch?.frame.width)!, rowHeight / 2)
            self.addSubview(cellSwitch!)
        } else {
            // title
            cellTitle = UILabel(frame: CGRectMake(10, 0, 105, rowHeight))
            cellTitle?.adjustsFontSizeToFitWidth = true
            cellTitle?.text = data.title
            self.addSubview(cellTitle!)

            // content
            cellContent = RLTextField(textFieldData: cellData!)
            cellContent?.type = RLTextFieldType(rawValue: self.cellType!.rawValue)
            cellContent?.frame = CGRectMake(125, 0, UIScreen.mainScreen().bounds.width - 130, rowHeight)
            if self.cellType == .Password {
                cellContent?.secureTextEntry = true
            }
            cellContent?.placeholder = cellData?.placeholder
            cellContent?.returnKeyType = .Done
            self.addSubview(cellContent!)
        }
    }
}
