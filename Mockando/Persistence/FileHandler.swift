// The MIT License (MIT)
//  FileHandler.swift
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


class FileHandler {
    
    /// Create necessary sub folders before creating a file
    static func createSubfoldersBeforeCreatingFile(at url: URL) throws {
        do {
            let subfolderUrl = url.deletingLastPathComponent()
            var subfolderExists = false
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: subfolderUrl.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    subfolderExists = true
                }
            }
            if !subfolderExists {
                try FileManager.default.createDirectory(at: subfolderUrl, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            throw error
        }
    }

    /// Create and returns a URL constructed from specified directory/path
    static func createURL(for path: String?, in directory: Directory) throws -> URL {
        let filePrefix = "file://"
        var validPath: String? = nil
        if let path = path {
            do {
                validPath = try getValidFilePath(from: path)
            } catch {
                throw error
            }
        }
        var searchPathDirectory: FileManager.SearchPathDirectory
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        case .applicationSupport:
            searchPathDirectory = .applicationSupportDirectory
        case .temporary:
            if var url = URL(string: NSTemporaryDirectory()) {
                if let validPath = validPath {
                    url = url.appendingPathComponent(validPath, isDirectory: false)
                }
                if url.absoluteString.lowercased().prefix(filePrefix.count) != filePrefix {
                    let fixedUrlString = filePrefix + url.absoluteString
                    url = URL(string: fixedUrlString)!
                }
                return url
            } else {
                throw createError(
                    .couldNotAccessTemporaryDirectory,
                    description: "Could not create URL for \(directory.pathDescription)/\(validPath ?? "")",
                    failureReason: "Could not get access to the application's temporary directory.",
                    recoverySuggestion: "Use a different directory."
                )
            }
        case .sharedContainer(let appGroupName):
            if var url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) {
                if let validPath = validPath {
                    url = url.appendingPathComponent(validPath, isDirectory: false)
                }
                if url.absoluteString.lowercased().prefix(filePrefix.count) != filePrefix {
                    let fixedUrl = filePrefix + url.absoluteString
                    url = URL(string: fixedUrl)!
                }
                return url
            } else {
                throw createError(
                    .couldNotAccessSharedContainer,
                    description: "Could not create URL for \(directory.pathDescription)/\(validPath ?? "")",
                    failureReason: "Could not get access to shared container with app group named \(appGroupName).",
                    recoverySuggestion: "Check that the app-group name in the entitlement matches the string provided."
                )
            }
        }
        if var url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            if let validPath = validPath {
                url = url.appendingPathComponent(validPath, isDirectory: false)
            }
            if url.absoluteString.lowercased().prefix(filePrefix.count) != filePrefix {
                let fixedUrlString = filePrefix + url.absoluteString
                url = URL(string: fixedUrlString)!
            }
            return url
        } else {
            throw createError(
                .couldNotAccessUserDomainMask,
                description: "Could not create URL for \(directory.pathDescription)/\(validPath ?? "")",
                failureReason: "Could not get access to the file system's user domain mask.",
                recoverySuggestion: "Use a different directory."
            )
        }
    }
}
