//
//  MulticastDelegateTest.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import XCTest
@testable import Discountcard

protocol FakeBroadcaster: class {
    func broadcast(message: String)
}

class Child: FakeBroadcaster {
    
    var message: String?
    
    func broadcast(message: String) {
        self.message = message
    }
}

class MulticastDelegateTest: XCTestCase {
    
    var delegates: MulticastDelegate<FakeBroadcaster>!
    var childOne: Child!
    var childTwo: Child!
    
    override func setUp() {
        super.setUp()
        delegates = MulticastDelegate<FakeBroadcaster>()
        childOne = Child()
        childTwo = Child()
    }
    
    func testBroadcasterIsBroadcasting() {
        delegates.add(childOne)
        delegates.add(childTwo)
        delegates.invoke { fbc in
            fbc.broadcast(message: "hey")
        }
        
        XCTAssertEqual(childOne.message, "hey")
        XCTAssertEqual(childTwo.message, "hey")
    }
    
    func testDelegateIsRemovedWhenDeallocated() {
        var optionalChild: Child? = Child()
        
        delegates.add(optionalChild!)
        delegates.invoke { fbc in
            fbc.broadcast(message: "hey")
        }
        XCTAssertEqual(optionalChild!.message, "hey")
        
        optionalChild = nil
    }
}
