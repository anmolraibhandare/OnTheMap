//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Anmol Raibhandare on 7/22/20.
//  Copyright © 2020 Anmol Raibhandare. All rights reserved.
//

import Foundation
import UIKit


class ListViewController: UITableViewController {

    // MARK: Outlets and Properties
    
    @IBOutlet var studentListView: UITableView!
    var students = [StudentLocation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getStudentList()
    }

    // MARK: Refresh button tapped
    
    @IBAction func refresh(_ sender: Any) {
        getStudentList()
    }
    
    // MARK: Get all student list
    
    func getStudentList() {
        UdacityClient.getStudentLocation { (students, error) in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    
    // MARK: - UITableViewDelegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath)
        
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        if let url = URL(string: student.mediaURL ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
