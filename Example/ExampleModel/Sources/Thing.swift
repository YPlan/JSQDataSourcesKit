//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://jessesquires.com/JSQDataSourcesKit
//
//
//  GitHub
//  https://github.com/jessesquires/JSQDataSourcesKit
//
//
//  License
//  Copyright © 2015 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation
import CoreData
import UIKit


public enum Color: String {
    case Red
    case Blue
    case Green

    var displayColor: UIColor {
        switch(self) {
        case .Red: return .redColor()
        case .Blue: return .blueColor()
        case .Green: return .greenColor()
        }
    }
}


public class Thing: NSManagedObject {

    // MARK: Properties

    @NSManaged public var name: String

    @NSManaged public var colorName: String

    public var color: Color {
        get {
            return Color(rawValue: colorName)!
        }
        set {
            colorName = newValue.rawValue
        }
    }

    public var displayName: String {
        return "Thing \(name)"
    }

    public var displayColor: UIColor {
        return color.displayColor
    }

    public override var description: String {
        get {
            return "<Thing: \(name), \(color)>"
        }
    }

    // MARK: Init

    public init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Thing", inManagedObjectContext: context)!
        super.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }


    // MARK: Methods

    public func changeColorRandomly() {
        color = randomColor(withoutColor: color)
    }

    public func changeNameRandomly() {
        name = randomName()
    }

    public func changeRandomly() {
        changeColorRandomly()
        changeNameRandomly()
    }


    // MARK: Class

    public class func newThing(context: NSManagedObjectContext) -> Thing {
        let t = Thing(context: context)
        t.color = randomColor(withoutColor: nil)
        t.name = randomName()
        return t
    }

    public class func newFetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Thing")
        request.sortDescriptors = [
            NSSortDescriptor(key: "colorName", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        return request
    }
}


private func randomColor(withoutColor color: Color?) -> Color {
    var colorSet = Set(arrayLiteral: Color.Red, Color.Blue, Color.Green)
    if let color = color {
        colorSet.remove(color)
    }
    let colors = Array(colorSet)
    return colors[Int(arc4random_uniform(UInt32(colors.count)))]
}


private func randomName() -> String {
    return NSUUID().UUIDString.componentsSeparatedByString("-").first!
}
