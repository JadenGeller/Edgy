//
//  EdgyTests.swift
//  EdgyTests
//
//  Created by Jaden Geller on 12/29/15.
//  Copyright © 2015 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Edgy

class EdgyTests: XCTestCase {
    
    func testConnectedComponents() {
        var graph = Graph(nodes: [1, 2, 3, 5, 6, 7, 10])
        
        graph.addEdge(1, 2)
        graph.addEdge(2, 3)
        graph.addEdge(3, 1)
        graph.addEdge(1, 10)
        
        graph.addEdge(5, 6)
        graph.addEdge(6, 7)
        graph.addEdge(7, 5)

        let components = graph.connectedComponents
        XCTAssertTrue(components.contains { graph in
            graph.nodes == Set([1, 2, 3, 10])
        })
        XCTAssertTrue(components.contains { graph in
            graph.nodes == Set([5, 6, 7])
        })
        XCTAssertEqual(2, components.count)
    }
    
}
