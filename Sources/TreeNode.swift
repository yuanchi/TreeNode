open class TreeNode{
    public weak var parent: TreeNode?
    public var children: [TreeNode] = []

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

    func find(by filter: (_: TreeNode) -> Bool, as result: inout [TreeNode]) {
      if filter(self) {
          result.append(self)
      }
      for child in children {
        child.find(by: filter, as: &result)
      }
    }

    public func find(by filter: (_: TreeNode) -> Bool) -> [TreeNode] {
      var result: [TreeNode] = []
      find(by: filter, as: &result)
      return result
    }

    public func findChildBy<T: TreeNode>(idx: [Int]) -> T? {
      var child: TreeNode? = nil
      var group = children
      for i in idx {
        guard i < group.endIndex else {
          return nil
        }
        child = group[i]
        group = child!.children
      }
      return child as? T
    }

    open subscript(idx: Int...) -> TreeNode? {
      return findChildBy(idx: idx)
    }

    public func getRoot<Root: TreeNode>() -> Root? {
      let topMost = self.topMost(as: TreeNode.self)
      return topMost as? Root
    }
    /**
    * get the most top element of the tree, and try to downcast
    */
    public func topMost<T: TreeNode>(`as`: T.Type) -> T? {
      var last = self
      while let p = last.parent {
        last = p
      }
      return last as? T
    }
    /**
     * from self upward checking the closest element with the same type
     */
    public func closest<T: TreeNode>(toExact type: T.Type) -> T? {
      var last = self
      if type(of: last) == type {
        return last as? T
      }
      while let p = last.parent {
        last = p
        if type(of: last) == type {
          return last as? T
        }
      }
      return nil
    }
    /*
    * from self upward checking the top most element with the same type
    */
    public func topMost<T: TreeNode>(toExact type: T.Type) -> T? {
      var last = self
      var found: TreeNode? = nil
      if(type(of: last) == type) {
        found = last
      }
      while let p = last.parent {
        if(type(of: p) == type) {
          found = p
        }
        last = p
      }
      return found as? T
    }
    /**
     * from self upward checking the closest element whose type is subClass
     */
    public func closest<T: TreeNode>(to: T.Type) -> T? {
      var last = self
      if last is T {
        return last as? T
      }
      while let p = last.parent {
        last = p
        if last is T {
          return last as? T
        }
      }
      return nil
    }
    /*
    * from self upward checking the top most element whose type is subClass
    */
    public func topMost<T: TreeNode>(to: T.Type) -> T? {
      var last = self
      var found: TreeNode? = nil
      if last is T {
        found = last
      }
      while let p = last.parent {
        if p is T {
          found = p
        }
        last = p
      }
      return found as? T
    }
    public func config(status setStatus: (_: TreeNode) ->  Void) -> Self {
      setStatus(self)
      return self
    }

    /*
    * subclass should override this method
    */
    open func copy() -> Self {
      let copied = type(of: self).init()
      // TODO copy other properties; what about parent property?
      for child in children {
         _ = copied.add(child: child.copy())
      }
      return copied
    }
}
