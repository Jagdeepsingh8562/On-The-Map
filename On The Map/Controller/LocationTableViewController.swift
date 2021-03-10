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
    
    func apicall() {
        UdacityAPI.getStudentLocation(completion: handleStudentResponse(success:error:))
    }
    func handleStudentResponse(success: Bool, error: Error?) {
        if success {
            student.removeAll()
            student.append(contentsOf: UdacityAPI.Auth.students)
            tableView.reloadData()
            print("****sucess&&&")
            
        }
        else {
            print(error ?? "")
        }
    }
    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.logoutRequest { (success, error) in
            if success {
                print("logout")
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        apicall()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = student[indexPath.row].firstName + student[indexPath.row].lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: student[indexPath.row].mediaURL)!, options: [:], completionHandler: nil)
    }
    @IBAction func addLocation(_ sender: Any) {
        print("something")
        performSegue(withIdentifier: "addStudentLocation", sender: nil)
       
    }
}
