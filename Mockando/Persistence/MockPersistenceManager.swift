// The MIT License (MIT)
//  MockPersistenceManager.swift
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

enum MockPersistenceError: Error {
    case fileNameError

}

class MockPersistenceManager {
    /// Save codable struct to disk as JSON data
    ///
    /// - Parameters:
    ///   - value: the Encodable value to store
    ///   - directory: user directory to store the file in
    ///   - path: file location to store the data .
    ///   - encoder: custom JSONEncoder to encode value
    /// - Throws: Error if there were any issues encoding the struct or writing it to disk

    public static func save<T: Encodable>(_ value: T, to directory: Directory, as path: String, encoder: JSONEncoder = JSONEncoder()) throws {
        if path.hasSuffix("/") {
            throw MockPersistenceError.fileNameError
        }
        do {
            let url = try FileHandler.createURL(for: path, in: directory)
            let data = try encoder.encode(value)
            try FileHandler.createSubfoldersBeforeCreatingFile(at: url)
            try data.write(to: url, options: .atomic)
        } catch {
            throw error
        }
    }

    /// Retrieve and decode a decodable from a file on disk
    ///
    /// - Parameters:
    ///   - path: path of the file holding desired data
    ///   - directory: user directory to retrieve the file from
    ///   - type: struct type (i.e. Message.self or [Message].self)
    ///   - decoder: custom JSONDecoder to decode existing values
    /// - Returns: decoded data
    /// - Throws: Error if there were any issues retrieving the data or decoding it to the specified type
    static func load<T: Decodable>(_ path: String, from directory: Directory, as type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        if path.hasSuffix("/") {
            throw MockPersistenceError.fileNameError
        }
        do {
            let url = try FileHandler.getExistingFileURL(for: path, in: directory)
            let data = try Data(contentsOf: url)
            let value = try decoder.decode(type, from: data)
            return value
        } catch {
            throw error
        }
    }
}
