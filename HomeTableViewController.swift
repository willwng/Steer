//
//  HomeTableViewController.swift
//  Steer
//
//  Created by Mac Sierra on 12/24/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import UIKit
import Alamofire
import iCalKit
class HomeTableViewController: UITableViewController {

    //MARK: Properties

    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClassData()
        // Load the sample data.
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
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "HomeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HomeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let course = courses[indexPath.row]
        
        cell.classLabel.text = course.title
        cell.taskLabel.text = course.description

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Private Methods
    
    private func loadClassData() {
        
        let coursesData = [
            CourseData(name: "English 10 H: Steele, George", url: "https://raw.githubusercontent.com/kiliankoe/iCalKit/master/Tests/example.ics"),
            CourseData(name: "Physics H: Hosey, Daniel", url: "https://raw.githubusercontent.com/wackymaster/SteerIOS/master/example.ics"),
            CourseData(name: "Phyiscal Education", url: "https://www.pittsfordschools.org/site/handlers/icalfeed.ashx?MIID=29561")
        ]
        
        
        for classes in coursesData{
            var data = ""
            let url = URL(string: classes.url)
            let cals = try! iCal.load(url: url!)
            for cal in cals {
                for event in cal.subComponents where event is Event {
                    print(event)
                    data += "\n"
                    data += String(describing: event)
                }
            }
            let class1 = Course(title: classes.name, description: data)
            courses += [class1]
        }
    }
}

