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
            student.removeAll()
            self.student.append(contentsOf: UdacityAPI.Auth.students)
            tableView.reloadData()
            
        }else {
            guard let error = error else {
                self.showAlert(message: "Something Wrong please try again", title: "Error")
                return
            }
            self.showAlert(message: error.localizedDescription, title: "Error")
        }
    }
    @IBAction func logoutButton(_ sender: Any) {
        UdacityAPI.logoutRequest { (success, error) in
            if success {
                print("logout")
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
                
            } else {
                guard let error = error else {
                    self.showAlert(message: "Something Wrong please try again", title: "Error")
                    return
                }
                self.showAlert(message: error.localizedDescription, title: "Error")
            }
        }
    }
    func apicall() {
             UdacityAPI.getStudentLocation(completion: handleStudentResponse(success:error:))
        tableView.reloadData()
         }
    
    @IBAction func refreshTable(_ sender: Any) {
        apicall()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = student[indexPath.row].firstName + "" +  student[indexPath.row].lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        if(student[indexPath.row].firstName.lowercased().contains("Sellyyyyyyyyyy")) {
            print("loat", student[indexPath.row].latitude)
            print("long", student[indexPath.row].longitude)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openLink(student[indexPath.row].mediaURL)
    }
    @IBAction func addLocation(_ sender: Any) {
        performSegue(withIdentifier: "addStudentLocation", sender: nil)
       
    }
}
