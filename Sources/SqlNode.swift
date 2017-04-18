class SqlNode: TreeNode{
  func sqlNodePrint() {
    print("This is SqlNode Printing...")
  }
  override subscript(idx: Int...) -> SqlNode? { // override required
    return findChildBy(idx: idx)
  }
}
