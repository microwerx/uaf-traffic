//
//  SessionTests.swift
//  uaftrafficTests
//
//  Created by Christopher Bailey on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import XCTest
@testable import uaftraffic

class SessionTests: XCTestCase {
	var session: Session!
	
    override func setUp() {
        session = Session()
    }

    override func tearDown() {
        session = nil
    }
	
	// Sessions IDs should be auto-generated and unique
	func testSessionIdGeneration() {
		let session2 = Session()
		XCTAssertGreaterThan(session.id.count, 0)
		XCTAssertGreaterThan(session2.id.count, 0)
		XCTAssertNotEqual(session.id, session2.id)
	}

	// addCrossing method should work
	func testAddCrossing() {
        session.addCrossing(type: "car", from: "w", to: "n")
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
	}
	
	// addCrossing should work multiple times
	func testAddTwoCrossings() {
		// Test first crossing
		session.addCrossing(type: "car", from: "w", to: "n")
        XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
		
		// Test second crossing
		session.addCrossing(type: "pedestrian", from: "e", to: "s")
		XCTAssertEqual(session.crossings[1].type, "pedestrian")
		XCTAssertEqual(session.crossings[1].from, "e")
		XCTAssertEqual(session.crossings[1].to, "s")
		XCTAssertEqual(session.crossings.count, 2)
	}
	
	// undo should remove the last crossing
	func testUndo() {
		// Test first crossing
        session.addCrossing(type: "car", from: "w", to: "n")
        XCTAssertEqual(session.crossings[0].type, "car")
        XCTAssertEqual(session.crossings[0].from, "w")
        XCTAssertEqual(session.crossings[0].to, "n")
        XCTAssertEqual(session.crossings.count, 1)
        
        // Test second crossing
        session.addCrossing(type: "pedestrian", from: "e", to: "s")
        XCTAssertEqual(session.crossings[1].type, "pedestrian")
        XCTAssertEqual(session.crossings[1].from, "e")
        XCTAssertEqual(session.crossings[1].to, "s")
        XCTAssertEqual(session.crossings.count, 2)
		
		// Test undo second crossing
		session.undo()
		XCTAssertEqual(session.crossings[0].type, "car")
		XCTAssertEqual(session.crossings[0].from, "w")
		XCTAssertEqual(session.crossings[0].to, "n")
		XCTAssertEqual(session.crossings.count, 1)
	}
    
    // Sessions should randomly generate an ID for themselves
    func testRandomId() {
        let sess1 = Session()
        let sess2 = Session()
        XCTAssertNotEqual(sess1.id, sess2.id)
    }
    
    // Trying to call undo() on an empty session shouldn't crash
    func testEmptyUndo() {
        let session = Session()
        XCTAssertEqual(session.crossings.count, 0)
        session.undo()
        XCTAssertEqual(session.crossings.count, 0)
    }
}
