//
//  SessionManagerTests.swift
//  uaftrafficTests
//
//  Created by Christopher Bailey on 3/3/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import XCTest
@testable import uaftraffic

class SessionManagerTests: XCTestCase {
	var sessionManager: SessionManager!
	
    override func setUp() {
        emptyDocumentsDirectory()
		sessionManager = SessionManager()
    }

    override func tearDown() {
		sessionManager = nil
        emptyDocumentsDirectory()
    }
    
    func emptyDocumentsDirectory() {
        let documentsdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var fileURLs = [URL]()
        do {
            fileURLs = try FileManager.default.contentsOfDirectory(at: documentsdirectory, includingPropertiesForKeys: nil)
        } catch {
            print("Failed to list documents directory")
        }
        for file in fileURLs {
            do {
                try FileManager.default.removeItem(at: file)
            } catch {
                print("Failed to delete file %s", file.relativeString)
            }
        }
    }

	// A SessionManager with no sessions associated should return an empty array.
    func testEmptySessionManager() {
        XCTAssertTrue(sessionManager.getSessions().isEmpty)
    }

	// A session, once written, should be readable
	func testWriteSingleSession() {
		let session = Session()
		session.name = "test session"
        sessionManager.writeSession(session: session)
		let sessions = sessionManager.getSessions()
		XCTAssertEqual(sessions[0], session)
	}

	// A session, once written, should be readable from a different SessionManager
	func testWriteSingleSessionMultipleManagers() {
		// First
		let session = Session()
		session.name = "test session"
		sessionManager.writeSession(session: session)
		
		// Second
		let altManager = SessionManager()
		let sessions = altManager.getSessions()
		XCTAssertEqual(sessions[0], session)
	}
	
	// A session, once written, should be deletable
	func testDeleteSession() {
		let session1 = Session()
		let session2 = Session()
        sessionManager.writeSession(session: session1)
        sessionManager.writeSession(session: session2)
        sessionManager.deleteSession(session: session2)
		let remainingSessions = sessionManager.getSessions()
		XCTAssertEqual(remainingSessions.count, 1)
		XCTAssertEqual(remainingSessions[0], session1)
	}
	
	// A session, once written, should be deletable (alternate)
	func testDeleteSessionAlt() {
        let session1 = Session()
        let session2 = Session()
        sessionManager.writeSession(session: session1)
        sessionManager.writeSession(session: session2)
        sessionManager.deleteSession(session: session1)
		let remainingSessions = sessionManager.getSessions()
		XCTAssertEqual(remainingSessions.count, 1)
		XCTAssertEqual(remainingSessions[0], session2)
	}
	
	// A session, once written, should be deletable from a different manager
	func testDeleteSessionMultipleManagers() {
        let session1 = Session()
        let session2 = Session()
        sessionManager.writeSession(session: session1)
        sessionManager.writeSession(session: session2)
		
		let sessionManager2 = SessionManager()
        sessionManager2.deleteSession(session: session2)
		let remainingSessions = sessionManager2.getSessions()
		XCTAssertEqual(remainingSessions.count, 1)
		XCTAssertEqual(remainingSessions[0], session1)
	}
	
	// A session, once written, should be deletable from a different manager (alternate)
	func testDeleteSessionMultipleManagersAlt() {
        let session1 = Session()
        let session2 = Session()
        sessionManager.writeSession(session: session1)
        sessionManager.writeSession(session: session2)
		
		let sessionManager2 = SessionManager()
        sessionManager2.deleteSession(session: session1)
		let remainingSessions = sessionManager2.getSessions()
		XCTAssertEqual(remainingSessions.count, 1)
		XCTAssertEqual(remainingSessions[0], session2)
	}
}
