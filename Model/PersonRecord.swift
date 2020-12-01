//
//  PersonRecord.swift
//  PersonalOverView
//
//  Created by Jan Hovland on 05/10/2020.
//

import SwiftUI
import CloudKit

struct PersonRecord: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var firstName: String = ""
    var lastName: String = ""
    var personEmail: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var cityNumber: String = ""
    var city: String = ""
    var municipalityNumber: String = ""
    var municipality: String = ""
    var dateOfBirth = Date()
    var dateMonthDay: String = ""
    var gender: Int = 0
    var image: UIImage?
}
