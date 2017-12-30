//
//  Classes.swift
//  Steer
//
//  Created by Mac Sierra on 12/29/17.
//  Copyright © 2017 Will Wang. All rights reserved.
//

import Foundation

class Classes {
    var course : String
    var school : String
    var url: String
    
    init(course: String?, school: String?, url: String?){
        self.course = course!
        self.school = school!
        self.url = url!
    }
}
