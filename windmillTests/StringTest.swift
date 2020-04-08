//
//  StringTest.swift
//  windmillTests
//
//  Created by Markos Charatzas (markos@qnoid.com) on 19/3/18.
//  Copyright © 2014-2020 qnoid.com. All rights reserved.
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation is required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
//

import XCTest

@testable import Windmill

class StringTest: XCTestCase {

    func testExampleEmpty() {
        let url = Bundle(for: StringTest.self).url(forResource: "Empty", withExtension: "txt")!

        let string = try! String(contentsOf: url)
        let lineNumber = string.count(length: 0)
        
        XCTAssertEqual(1, lineNumber)
    }
    
    func testExample() {
        let url = Bundle(for: StringTest.self).url(forResource: "25Lines", withExtension: "txt")!
        
        let string = try! String(contentsOf: url)
        let lineNumber = string.count(length: 0)

        XCTAssertEqual(1, lineNumber)
    }
    
    func testExample2() {
        let url = Bundle(for: StringTest.self).url(forResource: "25Lines", withExtension: "txt")!
        
        let string = try! String(contentsOf: url)
        let lineNumber = string.count(length: 145)
        
        XCTAssertEqual(9, lineNumber)
    }
    
    func testExample3() {
        
        let url = Bundle(for: StringTest.self).url(forResource: "25Lines", withExtension: "txt")!
        
        let string = try! String(contentsOf: url)
        let lineNumber = string.count(length: 506)
        
        XCTAssertEqual(25, lineNumber)
    }
    
    func testExample4() {
        let url = Bundle(for: StringTest.self).url(forResource: "25Lines", withExtension: "txt")!
        
        let string = try! String(contentsOf: url)
        let lineNumber = string.count(length: 507)
        
        XCTAssertEqual(25, lineNumber)
    }
}
