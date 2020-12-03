//
//  PersonIndex.swift
//  TableViewIndexed (iOS)
//
//  Created by Jan Hovland on 03/12/2020.
//

import SwiftUI
import CloudKit

struct PersonIndex: Identifiable {
    var id = UUID()
    var indexLetter: String = ""
    var persons = [Person]()
}

