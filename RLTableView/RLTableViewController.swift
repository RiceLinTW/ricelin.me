//
//  RLTableViewController.swift
//  MyStaff
//
//  Created by RiceLin on 3/18/16.
//  Copyright © 2016 Rice. All rights reserved.
//

import UIKit

public class RLRow {
    
    var type                : RLTableViewCellType?
    var title               : String            = ""
    var key                 : String            = ""
    
    var placeholder         : String?
    
    var choice              : [[AnyObject]]?
    var relativeComponets   : Bool              = false
    var pickerTextSeparator : String?
    var datePickerMode      : UIDatePickerMode? = .Date
    var dateFormat          : String?
    var datePickerStartDate : NSDate?
    
    var checkedImageName    : String?
    var uncheckedImageName  : String?
    var detail              : Bool?
    
    var switchOn            : Bool?

    convenience init(StringTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.String
        self.placeholder = placeholder
    }
    
    convenience init(IntTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Int
        self.placeholder = placeholder
    }
    
    convenience init(PhoneTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Phone
        self.placeholder = placeholder
    }
    
    convenience init(EmailTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Email
        self.placeholder = placeholder
    }
    
    convenience init(UrlTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Url
        self.placeholder = placeholder
    }

    convenience init(PickerTypeTitle title : String, key : String, choice : [[AnyObject]], relativeComponets : Bool, placeholder : String?, separator : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Picker
        
        self.choice = choice
        self.relativeComponets = relativeComponets
        self.placeholder = placeholder
        self.pickerTextSeparator = separator
    }
    
    convenience init(DateTypeTitle title : String, key : String, placeholder : String?, mode : UIDatePickerMode?, dateFormat : String?, startDate: NSDate) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Date
        self.placeholder = placeholder
        self.datePickerMode = mode
        self.datePickerStartDate = startDate
        self.dateFormat = dateFormat
    }
    
    convenience init(PasswordTypeTitle title : String, key : String, placeholder : String?) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Password
        self.placeholder = placeholder
    }
    
    convenience init(SwitchTypeTitle title : String, key : String, on : Bool) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Switch
        self.switchOn = on
    }
    
    convenience init(CheckTypeTitle title : String, key : String, checkedImageName : String, uncheckedImageName : String, detail : Bool) {
        self.init()
        self.title = title
        self.key = key
        self.type = RLTableViewCellType.Check
        self.checkedImageName = checkedImageName
        self.uncheckedImageName = uncheckedImageName
        self.detail = detail
    }
    
}

public class RLTableViewData {
    
    var sectionTitle    : String? = ""
    var rows            : [RLRow] = []
    
    convenience public init(sectionTitle title : String?, rows : [RLRow]) {
        self.init()
        self.sectionTitle = title
        self.rows = rows
    }
}

class RLTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var rlTableView         : UITableView                   = UITableView()
    var dataSource          : [RLTableViewData]             = []
    var inputData           : NSMutableDictionary           = NSMutableDictionary()
    
    var hideNavigationBar   : Bool                          = false
    var tableViewFrame      : CGRect?
    
    var headerHeight        : CGFloat                       = 30
    var headerBgColor       : UIColor                       = UIColor.groupTableViewBackgroundColor()
    var headerTextAttribute : [String:AnyObject]?           = [
        NSForegroundColorAttributeName:UIColor.blackColor(),
        NSFontAttributeName:UIFont.boldSystemFontOfSize(18)
    ]
    
    var rowHeight           : CGFloat                       = 50
    
    var separatorColor      : UIColor                       = UIColor.groupTableViewBackgroundColor()
    var selectionStyle      : UITableViewCellSelectionStyle = .None
    
    var pickerIndexPath     : NSIndexPath?

    var titleAlignment      : NSTextAlignment               = .Right
    var contentAlignment    : NSTextAlignment               = .Right
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RLTableViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RLTableViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        var height = view.frame.height
        var originalY : CGFloat = 0
        
        if !hideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: false)
            height -= 44
            originalY += 44
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        if !prefersStatusBarHidden() {
            height -= 20
            originalY += 20
        }
        
        if tableViewFrame != nil {
            rlTableView.frame = tableViewFrame!
        } else {
            rlTableView.frame = CGRectMake(0, originalY, view.frame.width, height)
        }
        
        rlTableView.dataSource = self
        rlTableView.delegate = self
        rlTableView.separatorStyle = .None
        self.view.addSubview(rlTableView)
        // TODO: - should use autolayout or not?

        if inputData.count == 0 {
            if dataSource.count > 0 {
                for i in 0...dataSource.count - 1 {
                    let arr = dataSource[i].rows
                    if arr.count > 0 {
                        for j in 0...arr.count - 1 {
                            let type = arr[j].type
                            let key = arr[j].key
                            var value : AnyObject?
                            if type == RLTableViewCellType.Switch {
                                value = 0
                            } else if type == RLTableViewCellType.Check {
                                value = 0
                            } else {
                                value = ""
                            }
                            inputData.setValue(value!, forKey: key)
                        }
                    }
                }
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: -UIKeyboard Notifications
    func keyboardDidShow(notification : NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            rlTableView.contentInset = contentInsets
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        rlTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return dataSource[section].sectionTitle
//    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, headerHeight)
        view.backgroundColor = headerBgColor
        
        let label = UILabel()
        label.frame = CGRectMake(5, 0, UIScreen.mainScreen().bounds.width - 10, headerHeight)
        label.attributedText = NSAttributedString(string: dataSource[section].sectionTitle!, attributes: headerTextAttribute)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = dataSource[indexPath.section].rows[indexPath.row]
        let cell = RLTableViewCell(cellData: data, rowHeight: rowHeight)
        cell.cellContent?.text = self.inputData.objectForKey(data.key) as? String
    
        cell.selectionStyle = selectionStyle
        cell.cellTitle?.textAlignment = titleAlignment
        cell.cellContent?.textAlignment = contentAlignment
        
        cell.cellContent?.delegate = self
        
        cell.cellContent?.picker?.delegate = self
        cell.cellContent?.picker?.dataSource = self
        cell.checkBox?.addTarget(self, action: #selector(RLTableViewController.checkBoxAction(_:)), forControlEvents: .TouchUpInside)
        cell.cellSwitch?.addTarget(self, action: #selector(RLTableViewController.switchAction(_:)), forControlEvents: .ValueChanged)
        
        let separator = UIView(frame: CGRectMake(0, rowHeight - 1, UIScreen.mainScreen().bounds.width, 1))
        separator.backgroundColor = separatorColor
        cell.addSubview(separator)

        return cell
    }

    // MARK: - RLTableViewDelegate
    func switchAction(sender : UISwitch) {
        let cell = sender.superview as? RLTableViewCell
        inputData.setValue(sender.on ? 1 : 0, forKey: (cell?.cellData!.key)!)
    }
    
    func checkBoxAction(sender : UIButton) {
        sender.selected = !(sender.selected)
        let cell = sender.superview as? RLTableViewCell
        inputData.setValue(sender.selected ? 1 : 0, forKey: (cell?.cellData!.key)!)
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        pickerIndexPath = rlTableView.indexPathForCell(textField.superview as! UITableViewCell)
        let temp = textField as! RLTextField
        switch temp.type! {
        case .Picker :
            if temp.choice.count > 0 {
                if textField.text == "" {
                    for i in 0...temp.choice.count - 1 {
                        var separator = temp.pickerTextSeparator
                        if i == temp.choice.count - 1 {
                            separator = ""
                        }
                        textField.text! += "\(temp.picker!.delegate!.pickerView!(temp.picker!, titleForRow: 0, forComponent: i)!)\(separator)"
                    }
                } else {
                    textField.text = ""
                    for i in 0...temp.choice.count - 1 {
                        var separator = temp.pickerTextSeparator
                        if i == temp.choice.count - 1 {
                            separator = ""
                        }
                        textField.text! += "\(temp.picker!.delegate!.pickerView!(temp.picker!, titleForRow: temp.picker!.selectedRowInComponent(i), forComponent: i)!)\(separator)"
                    }
                }
                
            }
            break
        case .Date :
            textField.text = temp.dateFormatter.stringFromDate(temp.datePicker.date)
            break
        default :
            break
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let tf = textField as? RLTextField
        inputData.setValue(textField.text, forKey: (tf?.key)!)
    }
    
    // MARK: - UIPickerViewDelegate, UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        let cell = rlTableView.cellForRowAtIndexPath(pickerIndexPath!) as! RLTableViewCell
        let choice = cell.cellContent?.choice
        return choice!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let cell = rlTableView.cellForRowAtIndexPath(pickerIndexPath!) as! RLTableViewCell
        let choice = cell.cellContent?.choice
        if cell.cellContent?.relativeComponets == true {
            if component == 0 {
                return choice![component][row] as? String
            } else {
                let array = choice![component][pickerView.selectedRowInComponent(component - 1)] as! NSArray
                if row >= array.count {
                    return ""
                }
                return array[row] as? String
            }
        } else {
            return choice![component][row] as? String
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = rlTableView.cellForRowAtIndexPath(pickerIndexPath!) as! RLTableViewCell
        let choice = cell.cellContent?.choice

        if cell.cellContent?.relativeComponets == true {
            cell.cellContent?.text = ""
            if component != (choice?.count)! - 1 {
                pickerView.reloadComponent(component + 1)
                pickerView.selectRow(0, inComponent: component + 1, animated: false)
                for i in 0...(choice?.count)! - 1 {
                    var separator = cell.cellContent!.pickerTextSeparator
                    if i == (choice?.count)! - 1 {
                        separator = ""
                    }
                    cell.cellContent?.text! += "\(pickerView.delegate!.pickerView!(pickerView, titleForRow: pickerView.selectedRowInComponent(i), forComponent: i)!)\(separator)"
                }
            } else {
                let array = choice![component][pickerView.selectedRowInComponent(component - 1)] as! NSArray
                if row >= array.count {
                    return
                }
                for i in 0...(choice?.count)! - 1 {
                    var separator = cell.cellContent!.pickerTextSeparator
                    if i == (choice?.count)! - 1 {
                        separator = ""
                    }
                    if i == 0 {
                        cell.cellContent?.text! += "\(choice![i][pickerView.selectedRowInComponent(i)])\(separator)"
                    } else {
                        cell.cellContent?.text! += "\(array[row])\(separator)"
                    }
                }
            }
        } else {
            cell.cellContent!.text = ""
            for i in 0...choice!.count - 1 {
                var separator = cell.cellContent!.pickerTextSeparator
                if i == (choice?.count)! - 1 {
                    separator = ""
                }
                cell.cellContent!.text! += "\(choice![i][pickerView.selectedRowInComponent(i)])\(separator)"
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let cell = rlTableView.cellForRowAtIndexPath(pickerIndexPath!) as! RLTableViewCell
        let choice = cell.cellContent?.choice
        if cell.cellContent?.relativeComponets == true {
            if component == 0 {
                return choice![component].count
            } else {
                return (choice![component][pickerView.selectedRowInComponent(component - 1)] as! NSArray).count
            }
        } else {
            return choice![component].count
        }
    }

}
