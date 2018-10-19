// The MIT License (MIT)
//  Directory.swift
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

public enum Directory: Equatable {
    /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory.
    case documents

    /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
    case caches

    /// Data that is used only temporarily should be stored in the <Application_Home>/tmp directory. Although these files are not backed up to iCloud, remember to delete those files when you are done with them so that they do not continue to consume space on the user’s device.
    case temporary


    public var pathDescription: String {
        switch self {
        case .documents: return "<Application_Home>/Documents"
        case .caches: return "<Application_Home>/Library/Caches"
        case .temporary: return "<Application_Home>/tmp"
        }
    }

    static public func ==(lhs: Directory, rhs: Directory) -> Bool {
        switch (lhs, rhs) {
        case (.documents, .documents), (.caches, .caches), (.temporary, .temporary):
            return true
        default:
            return false
        }
    }
}
