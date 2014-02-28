class Branch
  attr_accessor :head, :tail

  def initialize(head: nil, tail: nil)
    @head = head
    @tail = tail
  end

  def list
    return list_from(:head) if head
    return list_from(:tail) if tail
    []
  end

  def ==(branch)
    self.list == branch.list
  end

  private

  def traverse(what)
    current = self.send(what)

    dir = :next     if what == :head
    dir = :previous if what == :tail

    while current.send(dir).is_a?(Goal)
      yield current
      current = current.send(dir)
    end
  end

  def list_from(what)
    result = []
    method = :<< if what == :head
    method = :unshift if what == :tail
    traverse(what) {|current| result.send method, current}
    result
  end
end
