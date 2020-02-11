//
//  StringExtension.swift
//  EtheriumDemoApp
//
//  Created by Rahul Dange on 11/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

extension String {
    func toHexEncodedString(uppercase: Bool = true, prefix: String = "", separator: String = "") -> String {
        return unicodeScalars.map { prefix + .init($0.value, radix: 16, uppercase: uppercase) } .joined(separator: separator)
    }
}
