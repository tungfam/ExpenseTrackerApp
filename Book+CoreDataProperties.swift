//
//  Book+CoreDataProperties.swift
//  OBSLY
//
//  Created by Tung Fam on 9/17/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book");
    }

    @NSManaged public var bookName: String?
    @NSManaged public var bookKey: String?

}
