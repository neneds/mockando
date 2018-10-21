// The MIT License (MIT)
//  MockRecordSession.swift
//  Mockando
//
//  Created by Dennis Merli Rodrigues on 18/10/18.
//  Copyright © 2018 Dennis Merli.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class MockRecordSession<T: Codable> {
    private(set) var sessionId: String?
    private(set) var jsonEncoder: JSONEncoder?
    private(set) var directoryToSave: Directory = .caches
    private(set) var file: String = ""
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    private(set) var recordedModels:[T] = []
    private(set) var isRecording: Bool = false

    convenience init(directoryToSave: Directory, file: String, encoder: JSONEncoder) {
        self.init()
        self.directoryToSave = directoryToSave
        self.file = file
        self.jsonEncoder = encoder
        self.sessionId = SessionIdGenerator.generateSessionId()
    }

    /// Start a session recording
    func startSessionRecord() {
        if isRecording { return }
        startDate = Date()
        isRecording = true
    }

    /// Stop session recording
    func stopSessionRecording() {
        if !isRecording { return }
        isRecording = false
        endDate = Date()
        saveRecordedSession()
    }

    /// Record a model instance on current recording session
    func recordModel(_ model: T) {
        recordedModels.append(model)
    }

    /// Save a recorded session
    private func saveRecordedSession() {
        do {
            try MockPersistenceManager.save(recordedModels, to: directoryToSave, as: file, encoder: jsonEncoder ?? JSONEncoder())
        } catch let error {

        }

    }
}
