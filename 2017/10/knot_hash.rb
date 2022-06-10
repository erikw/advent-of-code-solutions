module KnotHash
  class KnotHasher
    LIST_SIZE_DEFAULT = 256
    ROUNDS = 64
    BLOCK_SIZE = 16
    EXTRA_LENGTHS = [17, 31, 73, 47, 23]

    def initialize(list_size = LIST_SIZE_DEFAULT)
      @list_size = list_size
    end

    def simple_hash(lengths)
      root = init_ring
      round(lengths, root)
      root.value * root.next.value
    end

    def hash(lengths)
      root = init_ring
      lengths += EXTRA_LENGTHS
      skip_size = 0
      node = root
      ROUNDS.times do
        node, skip_size = round(lengths, node, skip_size)
      end
      to_hex(compress(root))
    end

    private

    def init_ring
      root = nil
      node = nil
      @list_size.times do |i|
        node_new = Node.new(i)
        if root.nil?
          root = node_new
        else
          node.next = node_new
        end
        node = node_new
      end
      node.next = root
      root
    end

    def round(lengths, node, skip_size = 0)
      lengths.each do |length|
        reverse(node, length)
        (length + skip_size).times do
          node = node.next
        end
        skip_size += 1
      end
      [node, skip_size]
    end

    def reverse(node, length, que = Thread::Queue.new)
      return if length == 0

      que << node.value
      reverse(node.next, length - 1, que)
      node.value = que.deq
    end

    def compress(node, length = @list_size)
      return [] if length == 0

      dense = compress(node.next, length - 1)
      if (length % BLOCK_SIZE) == 1
        dense.unshift(node.value)
      else
        dense[0] ^= node.value
      end
      dense
    end

    def to_hex(blocks)
      blocks.map { |v| v.to_s(16).rjust(2, '0') }.join
    end
  end

  class Node
    attr_accessor :value, :next

    def initialize(value)
      @value = value
      @next = nil
    end
  end
  private_constant :Node
end
