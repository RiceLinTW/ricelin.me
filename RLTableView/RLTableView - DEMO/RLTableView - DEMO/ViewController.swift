//
//  ViewController.swift
//  RLTableView - DEMO
//
//  Created by RiceLin on 9/2/16.
//  Copyright © 2016 Rice. All rights reserved.
//

import UIKit

class ViewController: RLTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.dataSource = [
            RLTableViewData(sectionTitle: "Section A", rows: [
                RLRow(EmailTypeTitle: "E-mail Type", key: "Email", placeholder: ""),
                RLRow(IntTypeTitle: "Int Type", key: "Int", placeholder: ""),
                RLRow(PasswordTypeTitle: "Password Type", key: "Password", placeholder: ""),
                RLRow(PhoneTypeTitle: "Phone Type", key: "Phone", placeholder: ""),
                RLRow(StringTypeTitle: "String Type", key: "String", placeholder: ""),
                RLRow(SwitchTypeTitle: "Switch Type", key: "Switch", on: true),
                RLRow(UrlTypeTitle: "Url Type", key: "Url", placeholder: "")
                ]),
            RLTableViewData(sectionTitle: "Section B", rows: [
                RLRow(DateTypeTitle: "Date Type", key: "Date", placeholder: "", mode: .Date, dateFormat: "yyyy/MM/dd", startDate: NSDate()),
                RLRow(PickerTypeTitle: "Picker Type", key: "Picker", choice: [["Choice A", "Choice B", "Choice C"]], relativeComponets: false, placeholder: "", separator: "")
                ])
        ]
        
        let donebutton = UIBarButtonItem(title: "Show", style: .Done, target: self, action: #selector(ViewController.doneAction))
        self.navigationItem.rightBarButtonItem = donebutton
    }

    func doneAction() {
        let alert = UIAlertController(title: "Data", message: String(format: "%@", self.inputData), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

