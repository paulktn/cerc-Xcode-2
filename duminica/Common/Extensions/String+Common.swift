//
//  String+Common.swift
//  duminica
//
//  Created by Olexa Boyko on 26.11.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
