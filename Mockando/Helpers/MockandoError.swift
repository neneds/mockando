// The MIT License (MIT)
//  MockandoError.swift
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


class MockandoError: NSError {
    class var errorDomain: String {
        return Bundle.main.bundleID
    }

    class func unknown() -> NSError {
        return NSError(domain: MockandoError.errorDomain,
                       code: 115,
                       userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
    }

    class func cannotParse() -> NSError {
        return NSError(domain: MockandoError.errorDomain, code: 116, userInfo: [NSLocalizedDescriptionKey: "Could not parse"])
    }

    class func nilParameter(parameter: String) -> NSError {
        return NSError(domain: MockandoError.errorDomain, code: 121, userInfo: [NSLocalizedDescriptionKey: "Nil parameter: \(parameter)"])
    }

    class func otherError(reason: String) -> NSError {
        return NSError(domain: MockandoError.errorDomain, code: 122, userInfo: [NSLocalizedDescriptionKey: reason])
    }
}
