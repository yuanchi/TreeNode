import XCTest
@testable import TreeNode

class TreeNodeTests: XCTestCase {

    func addThenReturnParent() {
      let root = SqlNode()
      let child = SelectNode()
      let rootSelf: Any = root.add(child: child)

      XCTAssertTrue(rootSelf is SqlNode)
    }

    func insertThenReturnChild() {
      let root = TreeNode()
      let child = SelectNode()
      let childSelf: Any = root.insert(child: child)

      XCTAssertTrue(childSelf is SelectNode)
    }

    func findFirst() {
      let root = TreeNode()
      let c1 = SqlNode()
      let c2 = SelectNode()

      _ = root.add(child: c1)
      _ = root.add(child: c2)

      let found = root.findFirst(by: {$0 is SelectNode})
      XCTAssertTrue(found! is SelectNode)
    }

    func subscriptGetChild() {
      let root = TreeNode()
      let c1 = SqlNode()
      let c2 = SelectNode()
      let c3 = TreeNode()
      let c4 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c1_c2_c1 = SqlNode()
      let c1_c2_c2 = TreeNode()
      let c1_c2_c3 = SqlNode()
      let c3_c1 = SelectNode()
      let c3_c2 = TreeNode()

      _ = root.add(children: c1, c2, c3, c4)

      let c2Self: AnyObject = root[1]!
      let c3Self: AnyObject = root[2]! // if root is SqlNode, this downcast will fail, becuase SqlNode overrides subscript
      let c4Self: AnyObject = root[3]!

      XCTAssertTrue(c2Self is SelectNode)
      XCTAssertTrue(c2Self === c2)
      XCTAssertTrue(c3Self is TreeNode)
      XCTAssertTrue(c3Self === c3)
      XCTAssertTrue(c4Self is SqlNode)
      XCTAssertTrue(c4Self === c4)

      _ = c1.add(children: c1_c1, c1_c2)
      _ = c1_c2.add(children: c1_c2_c1, c1_c2_c2, c1_c2_c3)
      _ = c3.add(children: c3_c1, c3_c2)

      XCTAssertTrue(root[0, 1, 2] != nil)
      XCTAssertTrue(root[0, 1, 2]! as AnyObject is SqlNode)
      XCTAssertTrue(root[0, 2] == nil)
      XCTAssertTrue(root[0, 2, 1] == nil)
    }

    func getRoot() {
      let root = SelectNode()
      let c1 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c2 = SqlNode()
      let c2_c1 = TreeNode()

      _ = root.add(children: c1, c2)
      _ = c1.add(children: c1_c1, c1_c2)
      _ = c2.add(child: c2_c1)

      let rootFound: SqlNode = c2_c1.getRoot() as! SqlNode
      XCTAssertTrue(rootFound is SelectNode)
      XCTAssertTrue(rootFound === root)
    }

    func topMostAs() {
      let root = SelectNode()
      let c1 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c1_c2_c1 = SelectNode()
      let c1_c2_c2 = SqlNode()
      let c2 = SqlNode()
      let c2_c1 = TreeNode()

      _ = c1_c2.add(children: c1_c2_c1, c1_c2_c2)
      let f1 = c1_c2_c1.topMost(as: TreeNode.self)
      XCTAssertTrue(c1_c2 === f1)
      _ = c1.add(children: c1_c1, c1_c2)
      let f2 = c1_c2_c1.topMost(as: SqlNode.self)
      XCTAssertTrue(c1 === f2)
      _ = c2.add(child: c2_c1)
      _ = root.add(children: c1, c2)
      let f3 = c1_c2_c1.topMost(as: TreeNode.self)
      XCTAssertTrue(root === f3)
    }

    func topMostTo() {
      let root = SelectNode()
      let c1 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c1_c2_c1 = SelectNode()
      let c1_c2_c2 = SqlNode()
      let c2 = SqlNode()
      let c2_c1 = TreeNode()

      _ = c1_c2.add(children: c1_c2_c1, c1_c2_c2)
      let f1 = c1_c2_c1.topMost(to: TreeNode.self)
      XCTAssertTrue(c1_c2 === f1)
      _ = c1.add(children: c1_c1, c1_c2)
      let f2 = c1_c2_c1.topMost(to: TreeNode.self)
      XCTAssertTrue(c1_c2 === f2)
      XCTAssertFalse(c1 === f2)
      _ = c2.add(child: c2_c1)
      _ = root.add(children: c1, c2)
      let f3 = c1_c2_c1.topMost(to: SelectNode.self)
      XCTAssertTrue(root === f3)
      XCTAssertFalse(c1_c2_c1 === f3)
    }

    func closest() {
      let root = SelectNode()
      let c1 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c1_c2_c1 = SelectNode()
      let c1_c2_c2 = SqlNode()
      let c2 = SqlNode()
      let c2_c1 = TreeNode()

      _ = c1_c2.add(children: c1_c2_c1, c1_c2_c2)
      let f1 = c1_c2_c1.closest(to: TreeNode.self)
      XCTAssertTrue(c1_c2 === f1)
      _ = c1.add(children: c1_c1, c1_c2)
      let f2 = c1_c2_c1.closest(to: TreeNode.self)
      XCTAssertTrue(c1_c2 === f2)
      XCTAssertFalse(c1 === f2)
      _ = c2.add(child: c2_c1)
      _ = root.add(children: c1, c2)
      let f3 = c1_c2_c1.closest(to: SelectNode.self)
      XCTAssertFalse(root === f3)
      XCTAssertTrue(c1_c2_c1 === f3)
    }

    func config() {
      let node = TreeNode()
      _ = node.config(status: {_ = $0.add(children: SqlNode(), SelectNode(), TreeNode())})
      XCTAssertEqual(node.children.count, 3)
    }

    func copy() {
      let root = TreeNode()
      let c1 = SqlNode()
      let c1_c1 = SelectNode()
      let c1_c2 = TreeNode()
      let c2 = SelectNode()
      let c2_c1 = TreeNode()
      let c2_c2 = SqlNode()

      _ = root.add(children: c1, c2)
      _ = c1.add(children: c1_c1, c1_c2)
      _ = c2.add(children: c2_c1, c2_c2)

      let rootCopy = root.copy()
      XCTAssertTrue((rootCopy[0, 1]! as AnyObject) is TreeNode)
      XCTAssertFalse(rootCopy[0, 1]! === c1_c2)
      XCTAssertTrue(rootCopy[1, 1]! as AnyObject is SqlNode)
      XCTAssertFalse(rootCopy[1, 1]! === c2_c2)
      XCTAssertTrue(rootCopy[0, 0]! as AnyObject is SelectNode)
      XCTAssertFalse(rootCopy[0, 0]! === c1_c1)
    }
    static var allTests = [
        ("addThenReturnParent", addThenReturnParent),
        ("insertThenReturnChild", insertThenReturnChild),
        ("findFirst", findFirst),
        ("subscriptGetChild", subscriptGetChild),
        ("getRoot", getRoot),
        ("config", config),
        ("copy", copy),
        ("topMostAs", topMostAs),
        ("topMostTo", topMostTo),
        ("closest", closest)
    ]
}
