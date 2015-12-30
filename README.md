# Edgy

Edgy provides a bidirectional value-semantic `Graph` type that can be used to form arbitrary graphs containing hashable nodes. Any `Hashable` type can be used as a node, such as an `Int` or a `String`. If two nodes have identity equality, then they represent the same exact node.
```swift
var codeGraph = Graph(nodes: ["Swift", "Haskell", "Rust", "C", "C++", "Objective-C", "Ruby"])
codeGraph.addEdge("Swift", "Haskell")
codeGraph.addEdge("Swift", "Objective-C")
codeGraph.addEdge("C", "Objective-C")
codeGraph.addEdge("C++", "C")
codeGraph.addEdge("C++", "Rust")
```

If you do desire to create multiple nodes storing the same value but with different identity, use the `UniqueNode` wrapper type which uses class identity.
```swift
let (a, b, c) = (UniqueNode(1), UniqueNode(1), UniqueNode(2))
var testGraph = Graph(nodes: [a, b, c])
testGraph.addEdge(b, c)
print(testGraph.connectedComponents.count) // -> 2 (since a & b are distinct nodes)
```

Traverse the object graph by following adjacent nodes.
```swift
for node in codeGraph.adjacentNodes("Swift") {
  print(node + " is pretty similiar to Swift")
}
```
