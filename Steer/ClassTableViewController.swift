//
//  ClassTableViewController.swift
//  Steer
//
//  Created by Mac Sierra on 12/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import SQLite3
import Firebase

class ClassTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var ref: DatabaseReference!
    var db: OpaquePointer?
    var classe = [Classes]()
    var filteredClasses = [Classes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search Classes"
        searchController.searchBar.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        loadClassData()
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filteredClasses.count
        }
        
        return classe.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ClassTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClassTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ClassTableViewCell.")
        }
        
        let course: Classes
        if isFiltering() {
            course = filteredClasses[indexPath.row]
        } else {
            course = classe[indexPath.row]
        }
        cell.ClassName.text = course.course
        cell.ClassSchool.text = course.school
        cell.AddClass.setTitle("Add Class", for: .normal)
        cell.URL.text = course.url
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadClassData() {
        
        ref = Database.database().reference().child("Classes");
        
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.classe.removeAll()
            
            //iterating through all the values
            for classes in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let classObject = classes.value as? [String: AnyObject]
                let names  = classObject?["Name"]
                let schoolname  = classObject?["School"]
                let url = classObject?["url"]
                
                //creating artist object with model and fetched values
                let class1 = Classes(course: names as! String?, school : schoolname as! String?, url: url as! String?)
                
                self.classe += [class1]
            }
            
            //reloading the tableview
            self.tableView.reloadData()
        })
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredClasses = classe.filter({( classes : Classes) -> Bool in
            return classes.course.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ClassTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
