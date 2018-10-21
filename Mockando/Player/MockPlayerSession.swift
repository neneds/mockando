//
//  MockPlayerSession.swift
//  Mockando
//
//  Created by Dennis Merli Rodrigues on 20/10/18.
//  Copyright © 2018 Dennis Merli. All rights reserved.
//

import Foundation

public protocol MockPlayerSessionDelegate: class {
    func didReceiveNewItem<T>(_ item: T, currentIndex: IndexPath, playerSession: MockPlayerSession<T>)
    func didFailToLoadRecordedSession<T>(error: Error?, playerSession: MockPlayerSession<T>)
    func didFinishPlayingRecordedSession<T>(playerSession: MockPlayerSession<T>)
}

public class MockPlayerSession<T: Codable> {
    private(set) var jsonDecoder: JSONDecoder?
    private(set) var directoryOfFile: Directory = .caches
    private(set) var file: String = ""
    private(set) var startDate: Date?
    private(set) var endDate: Date?
    private(set) var archivedModels:[T] = []
    private(set) var currentItem: IndexPath?
    private(set) var isPlaying: Bool = false
    private      var timer: Timer?
    public var autoSkipInterval: TimeInterval = 2
    public weak var delegate: MockPlayerSessionDelegate?
    public var shouldRepeat: Bool = false

    public convenience init(directoryOfFile: Directory, file: String, decoder: JSONDecoder) {
        self.init()
        self.directoryOfFile = directoryOfFile
        self.file = file
        self.jsonDecoder = decoder
    }

    /// Play session record
    public func playSessionRecord(autoSkip: Bool = false) {
        if isPlaying { return }
        startDate = Date()
        isPlaying = true
        if autoSkip {
            setupSkipTimer()
        }
    }

    /// Load File from directory
    public func loadFileFromDirectory() {
        do {
            let data = try MockPersistenceManager.load(file, from: directoryOfFile, as: [T].self, decoder: jsonDecoder ?? JSONDecoder())
            archivedModels = data
        } catch let error {
            delegate?.didFailToLoadRecordedSession(error: error, playerSession: self)
        }
    }

    /// Stop playing the session record
    public func stopPlayingSessionRecord() {
        if !isPlaying { return }
        isPlaying = false
        endDate = Date()
        timer?.invalidate()
        self.currentItem = IndexPath(row: 0, section: 0)
    }

    /// Next Value of the record
    public func nextItem() {
        guard let currentItem = currentItem else {
            self.currentItem = IndexPath(row: 0, section: 0)
            return
        }
        var selectedModel: T
        if archivedModels.count - 1 == currentItem.row {
            if !shouldRepeat {
                delegate?.didFinishPlayingRecordedSession(playerSession: self)
                stopPlayingSessionRecord()
                return
            }
            self.currentItem = IndexPath(row: 0, section: 0)
            selectedModel = archivedModels[currentItem.row]
        } else {
            self.currentItem = IndexPath(row: currentItem.row + 1, section: 0)
            selectedModel = archivedModels[currentItem.row]
        }
        delegate?.didReceiveNewItem(selectedModel, currentIndex: currentItem, playerSession: self)
    }

    /// Previous Item
    public func previousItem() {
        guard let currentItem = currentItem else {
            self.currentItem = IndexPath(row: 0, section: 0)
            return
        }
        var selectedModel: T
        if archivedModels.isEmpty { return }
        self.currentItem = IndexPath(row: currentItem.row - 1, section: 0)
        if currentItem.row <= 0 {
            self.currentItem = IndexPath(row: archivedModels.count - 1, section: 0)
            selectedModel = archivedModels[currentItem.row]
        } else {
            self.currentItem = IndexPath(row: currentItem.row - 1, section: 0)
            selectedModel = archivedModels[currentItem.row]
        }

        delegate?.didReceiveNewItem(selectedModel, currentIndex: currentItem, playerSession: self)
    }

    private func setupSkipTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: autoSkipInterval, target: self, selector: #selector(callNextItem), userInfo: nil, repeats: true)
    }

    @objc private func callNextItem() {
        nextItem()
    }
}
