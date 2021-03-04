//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by Jagdeep Singh on 03/03/21.
//

import UIKit

class LocationTableViewController: UITableViewController{
   // @IBOutlet weak var tableView: UITableView!
    var student = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        UdacityAPI.getStudentLocation(completion: handleStudentResponse(success:error:))
    }
    func handleStudentResponse(success: Bool, error: Error?) {
        if success {
            student.append(contentsOf: UdacityAPI.Auth.student)
            print("****sucess&&&")
            tableView.reloadData()
        }
        else {
            print(error ?? "")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = student[indexPath.row].firstName + student[indexPath.row].lastName
        cell.imageView?.image = UIImage(systemName: "mappin.and.ellipse")
        return cell
    }
    @IBAction func addLocation(_ sender: Any) {
        print("something")
        performSegue(withIdentifier: "addStudentLocation", sender: nil)
       
    }
}
