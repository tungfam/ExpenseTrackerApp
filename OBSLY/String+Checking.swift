//
//  String+Checking.swift
//  OBSLY
//
//  Created by Tung Fam on 10/6/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import Foundation

extension String {
    var isAmountFormat: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self.characters).isSubset(of: nums)
    }
}
