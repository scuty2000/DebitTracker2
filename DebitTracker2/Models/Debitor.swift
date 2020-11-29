//
//  Debitor.swift
//  DebitTracker2
//
//  Created by Luca Scutigliani on 29/11/20.
//

import SwiftUI

struct Debitor: Codable, Identifiable {
    var id = UUID()
    var name: String
    var surname: String
    var debit: Int
    var color: String = ""
}
