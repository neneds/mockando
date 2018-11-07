//
//  MockPlayerSession.swift
//  Mockando
//
//  Created by Dennis Merli Rodrigues on 20/10/18.
//  Copyright © 2018 Dennis Merli. All rights reserved.
//

import Foundation

public protocol MockPlayerSessionDelegate: class {
    func didReceiveNewItem<T>(_ item: T, currentIndexRow: Int, playerSession: MockPlayerSession<T>)
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
    private(set) var currentItemRow: Int = 0
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
        self.currentItemRow = 0
    }

    /// Next Value of the record
    public func nextItem() {
        if !isPlaying { return }
        if currentItemRow < archivedModels.count - 1 {
            currentItemRow = currentItemRow + 1
            selectItem(row: currentItemRow)
        } else {
            if !shouldRepeat {
                delegate?.didFinishPlayingRecordedSession(playerSession: self)
                stopPlayingSessionRecord()
                return
            }
            currentItemRow = 0
            selectItem(row: currentItemRow)
        }
    }

    /// Previous Item
    public func previousItem() {
        if !isPlaying { return }
        if archivedModels.isEmpty { return }

        if currentItemRow <= 0 {
            if !shouldRepeat {
                delegate?.didFinishPlayingRecordedSession(playerSession: self)
                stopPlayingSessionRecord()
                return
            }
            currentItemRow = archivedModels.count - 1
            selectItem(row: currentItemRow)
        } else {
            currentItemRow = currentItemRow - 1
            selectItem(row: currentItemRow)
        }
    }

    private func selectItem(row: Int) {
        let selectedItem = archivedModels[row]
        delegate?.didReceiveNewItem(selectedItem, currentIndexRow: row, playerSession: self)
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
