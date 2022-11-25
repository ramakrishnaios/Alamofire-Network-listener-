//
//  ViewController.swift
//  NetworkListener
//
//  Created by Ramakrishna UTTI on 24/11/22.
//

import Alamofire
import UIKit

class ViewController: UIViewController, ReachabilityChanged {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       startObservingNetwork()
    }

    deinit {
        stopObservingNetwork()
    }

}

extension ViewController {

    func networkConnectionChanged() {
    }

}
