//
//  Volume.swift
//  AofF
//
//  Created by AJ Bronson on 12/23/16.
//  Copyright © 2016 AJ Bronson. All rights reserved.
//

import Foundation

import GRDB

class Volume {
    let id: Int
    let name: String
    
    init(row: Row) {
        id = row.value(named: "id")
        name = row.value(named: "name")
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
