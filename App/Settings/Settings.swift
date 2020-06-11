//
//  Settings.swift
//  App
//
//  Created by Siddiqur Rahmnan on 31/5/20.
//  Copyright © 2020 Siddiqur Rahmnan. All rights reserved.
//

import Foundation
private let dateFormat = "yyyyMMddHHmmss"
func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}
