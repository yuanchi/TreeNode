public class TreeNode{
    weak var parent: TreeNode?
    var children: [TreeNode] = []

    required public init(){} // for dynamic initialization use

    public func add(child: TreeNode) -> Self {
      children.append(child)
      child.parent = self
      return self
    }
    public func add(children: TreeNode...) -> Self {
      for child in children {
        _ = add(child: child)
      }
      return self
    }
    public func insert<Child: TreeNode>(child: Child) -> Child {
      _ = add(child: child)
      return child
    }

    public func findFirst(by filter: (_: TreeNode) -> Bool) -> TreeNode? {
      guard !filter(self) else {
        return self
      }
      for child in children {
        if let found = child.findFirst(by: filter) {
          return found
        }
      }
      return nil
    }

    func findChildBy<T: TreeNode>(idx: [Int]) -> T? {
      var child: TreeNode? = nil
      var group = children
      for i in idx {
        guard i <= group.endIndex else {
          return nil
        }
        child = group[i]
        group = child!.children
      }
      return child as! T?
    }

    subscript(idx: Int...) -> TreeNode? {
      return findChildBy(idx: idx)
    }

    public func getRoot<Root: TreeNode>() -> Root {
      var last = self
      while let p = last.parent {
        last = p
      }
      return last as! Root
    }

    public func config(status setStatus: (_: TreeNode) ->  Void) -> Self {
      setStatus(self)
      return self
    }

    /*
    * subclass should override this method
    */
    public func copy() -> Self {
      let copied = type(of: self).init()
      // TODO copy other properties; what about parent property?
      for child in children {
         _ = copied.add(child: child.copy())
      }
      return copied
    }
}
