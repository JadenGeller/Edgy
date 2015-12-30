
protocol GraphType {
	typealias Node: Hashable
	
	var nodes: Set<Node> { get }
	func adjacentNodes(node: Node) -> Set<Node>
}

protocol MutableGraphType: GraphType {
	mutating func addNode(node: Node)
	mutating func addEdge(lhs: Node, _ rhs: Node)
	init(nodes: Set<Node>)
	func subgraphWithNodes(nodes: Set<Node>) -> Graph<Node>
}

class EdgeBacking<Node: Hashable> {
	var nodesReachableFromNode = Dictionary<Node, Set<Node>>()
	
	init(nodesReachableFromNode: Dictionary<Node, Set<Node>> = [:]) {
		self.nodesReachableFromNode = nodesReachableFromNode
	}
	
	func copyByTrimmingIrrelevantNodes(relevantNodes relevantNodes: Set<Node>) -> EdgeBacking {
		var copy = Dictionary<Node, Set<Node>>()
		for (key, value) in nodesReachableFromNode {
			if relevantNodes.contains(key) {
				copy[key] = value.intersect(relevantNodes)
			}
		}
		return EdgeBacking(nodesReachableFromNode: copy)
	}
}

struct Graph<Node: Hashable>: MutableGraphType {
	private var edgeBacking = EdgeBacking<Node>()
	private(set) var nodes = Set<Node>()
	
	init(nodes: Set<Node> = []) {
		for node in nodes { addNode(node) }
	}
	
	func adjacentNodes(node: Node) -> Set<Node> {
		return (edgeBacking.nodesReachableFromNode[node] ?? []).intersect(nodes)
	}
	
	private mutating func requireUniqueBacking() {
		if !isUniquelyReferencedNonObjC(&edgeBacking) {
			edgeBacking = edgeBacking.copyByTrimmingIrrelevantNodes(relevantNodes: nodes)
		}
	}
	
	mutating func addNode(node: Node) {
		requireUniqueBacking()
		
		nodes.insert(node)
		edgeBacking.nodesReachableFromNode[node] = []
	}
		
	mutating func addEdge(lhs: Node, _ rhs: Node) {
		requireUniqueBacking()

		assert(nodes.contains(lhs) && nodes.contains(rhs), "Cannot add edge between nodes not in graph.")
		edgeBacking.nodesReachableFromNode[lhs]?.insert(rhs)
		edgeBacking.nodesReachableFromNode[rhs]?.insert(lhs)
	}
	
	func subgraphWithNodes(nodes: Set<Node>) -> Graph<Node> {
		var copy = Graph()
		copy.nodes = nodes
		copy.edgeBacking = edgeBacking
		return copy
	}
}

extension MutableGraphType {
	func subgraphWithNodes(nodes: Set<Node>) -> Self {
		var subgraph = Self(nodes: nodes)
		nodes.forEach { n in subgraph.adjacentNodes(n).forEach { a in subgraph.addEdge(n, a) } }
		return subgraph
	}
	
	func connectedComponent(withNode node: Node) -> Self {
		var traversedNodes = Set<Node>()
		
		var enqueuedNodes = [node]
		while let node = enqueuedNodes.popLast() {
			traversedNodes.insert(node)
			enqueuedNodes += adjacentNodes(node).filter { !traversedNodes.contains($0) }
		}

		return subgraphWithNodes(traversedNodes)
	}
	
	var connectedComponents: [Self] {
		var foundComponents = [Self]()
		
		var startingNodes = nodes
		while let node = startingNodes.first {
			let component = connectedComponent(withNode: node)
			startingNodes.subtractInPlace(component.nodes)
			foundComponents.append(component)
		}
		
		return foundComponents
	}
}