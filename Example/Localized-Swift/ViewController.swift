//
//  ViewController.swift
//  Localized-Swift
//
//  Created by ansari.ahmad@gmail.com on 01/17/2019.
//  Copyright (c) 2019 ansari.ahmad@gmail.com. All rights reserved.
//

import UIKit
import Localized_Swift

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var localizeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshLocalization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapLocalizeButton(_ sender: Any) {
        refreshLocalization()
    }

    func refreshLocalization() {
        textView.text = "Global cooling".localized()
    }
}

