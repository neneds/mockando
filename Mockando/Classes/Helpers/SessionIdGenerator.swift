//
//  SessionIdGenerator.swift
//  Mockando
//
//  Created by Dennis Merli Rodrigues on 20/10/18.
//  Copyright © 2018 Dennis Merli. All rights reserved.
//

import Foundation


public class SessionIdGenerator {
    
    public static func generateSessionId() -> String {
        return randomStringWithLength(7)
    }
    
    private static func randomStringWithLength(_ len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString = String()
        for _ in 0..<len {
            let length = UInt32(letters.count)
            let rand = arc4random_uniform(length)
            let index = String.Index(encodedOffset: Int(rand))
            randomString += String(letters[index])
        }
        return String(randomString)
    }
}
