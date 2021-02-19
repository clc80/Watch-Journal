//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Claudia Contreras on 4/28/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Identifiable {
    var id: String
    var title: String
    var bodyText: String
    var timestamp: Date
    var mood: String
    
    enum CodingKeys: String, CodingKey {
        case id = "identifier"
        case title
        case bodyText
        case timestamp
        case mood
    }
}
