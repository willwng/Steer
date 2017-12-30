//
//  ClassTableViewController.swift
//  Steer
//
//  Created by Mac Sierra on 12/28/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import SQLite3

class ClassTableViewController: UITableViewController {
    
    var db: OpaquePointer?
    var classe = [Classes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return classe.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "ClassTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClassTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ClassTableViewCell.")
        }
        
        let course = classe[indexPath.row]
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
        
        let coursesData = [
            Classes(course: "English 10H: Steele, George", school: "Pittsford Sutherland", url: "https://www.pittsfordschools.org/site/handlers/icalfeed.ashx?MIID=29561"),
            Classes(course: "Physics H: Hosey, Daniel", school: "Pittsford Sutherland", url: "https://www.pittsfordschools.org/site/handlers/icalfeed.ashx?MIID=32661"),
            Classes(course: "Pittsford Nordic", school: "Pittsford Sutherland", url: "https://www.pittsfordschools.org/site/handlers/icalfeed.ashx?MIID=21245")
        ]
        
        for classes in coursesData{
            let class1 = Classes(course: classes.course, school: classes.school, url: classes.url)
            classe += [class1]
        }
        
    }

}
