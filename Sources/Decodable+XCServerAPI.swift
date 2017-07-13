//===----------------------------------------------------------------------===//
//
// Decodable+XCServerAPI.swift
//
// Copyright (c) 2017 Richard Piazza
// https://github.com/richardpiazza/XCServerAPI
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//===----------------------------------------------------------------------===//

import Foundation
import CodeQuickKit

public extension Decodable {
    static func decode(json: String) -> Self? {
        var mutable = json
        while let range = mutable.rangeOfCharacter(from: CharacterSet.controlCharacters) {
            mutable.removeSubrange(range)
        }
        
        guard let data = mutable.data(using: .utf8) else {
            return nil
        }
        
        return decode(data: data)
    }
    
    static func decode(data: Data) -> Self? {
        do {
            return try XCServerJSONDecoder.default.decode(Self.self, from: data)
        } catch {
            print(error)
            Log.error(error, message: "Failed to decode type '\(String(describing: Self.self)): \(error.localizedDescription)'")
            return nil
        }
    }
}
