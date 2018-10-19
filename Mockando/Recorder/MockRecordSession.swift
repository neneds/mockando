//
//  MockRecordSession.swift
//  Mockando
//
//  Created by Dennis Merli Rodrigues on 18/10/18.
//  Copyright © 2018 Dennis Merli. All rights reserved.
//

import Foundation


class MockRecordSession<T: Codable> {
    var sessionId: String?
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    private(set) var recordedModels:[T]?
    private(set) var isRecording: Bool = false

    /// Start a session recording
    func startSessionRecord() {
        if isRecording { return }
        startDate = Date()
        isRecording = true
    }

    /// Stop session recording
    func stopSessionRecording(autoSave: Bool = true) {
        if !isRecording { return }
    }

    /// Record a model instance on current recording session
    func recordModel(_ model: T) {
        
    }
}
