//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var addLocationButton: UIButton!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "addStudentLocation", sender: nil)
    }
}
