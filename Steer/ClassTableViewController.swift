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
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search Classes or Schools"
        searchController.searchBar.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            //tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Classes.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Classes (id INTEGER PRIMARY KEY NOT NULL, name TEXT, url TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        loadClassData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.ClassName.sizeToFit()
        cell.ClassName.adjustsFontSizeToFitWidth = true
        cell.ClassSchool.text = course.school
        if rowExists(name: course.course) {
            cell.AddClass.setTitle("Added!", for: .normal)
            cell.AddClass.isEnabled = false
        } else {
            cell.AddClass.setTitle("Add Class", for: .normal)
            cell.AddClass.isEnabled = true
        }
        cell.URL.text = course.url
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.classe.removeAll()
            for classes in snapshot.children.allObjects as! [DataSnapshot] {
                let classObject = classes.value as? [String: AnyObject]
                let names  = classObject?["Name"]
                let schoolname  = classObject?["School"]
                let url = classObject?["url"]

                let class1 = Classes(course: names as! String?, school : schoolname as! String?, url: url as! String?)
                self.classe += [class1]
            }
            self.tableView.reloadData()
        })
    }
    
    func rowExists(name: String) -> Bool {
        let queryString = "SELECT * FROM Classes ORDER BY id"
        var stmt:OpaquePointer?
        names.removeAll()
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(errmsg)
            return false
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let coursename = String(cString: sqlite3_column_text(stmt, 1))
            names.append(coursename)
        }
        if names.contains(name) {
            return true
        } else {
            return false
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredClasses = classe.filter({( classes : Classes) -> Bool in
            if classes.course.lowercased().range(of: searchText.lowercased()) != nil {
                return classes.course.lowercased().contains(searchText.lowercased())
            } else {
                return classes.school.lowercased().contains(searchText.lowercased())
            }
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
