class Node
    attr_accessor :data, :parent, :lchild, :rchild
    def initialize(data = nil, parent = nil, lchild = nil, rchild = nil )
        @data = data
        @parent = parent
        @lchild = lchild
        @rchild = rchild
    end
end

class Tree
    attr_accessor :root
    def initialize(array)
        @root = self.build_tree(array)
    end

    def build_tree(array, parent = nil)
        return nil if array.empty?
        return Node.new(array[0], parent) if array.length < 2
        array.sort!.uniq!
        mid = (array.length)/2
        root = Node.new(array[mid], parent)
        root.lchild = build_tree(array[0..mid-1], root)
        root.rchild = build_tree(array[mid+1..-1], root)

        return root
    end

    def insert(value, node = @root)
        puts "#{value} exists already" if node.data == value
        temp_node = value > node.data ? node.rchild : node.lchild
        if !temp_node.lchild && value < temp_node.data
            temp_node.lchild = Node.new(value)
        elsif !temp_node.rchild && value > temp_node.data
            temp_node.rchild = Node.new(value)
        else
            insert(value, temp_node)
        end
    end

    def find_greatest_child(node)
        return node if node.rchild.nil?
        greatest_child = node.rchild
        find_greatest_child(greatest_child)
    end

    def delete(value, node = @root)
        if value < node.data
            return nil if node.lchild == nil
            delete(value, node.lchild)
        elsif value > node.data
            return nil if node.rchild == nil
            delete(value, node.rchild) 
        elsif value == node.data
            # if no child
            node = nil if node.lchild.nil? && node.rchild.nil?
            
            # if 1 child
            
            if node.lchild.nil?
                node.data = node.rchild.data
                node.rchild = nil
                node.rchild.lchild.nil? ? node.rchild = nil : node.rchild = node.rchild.lchild
            elsif node.rchild.nil?
                node.data = node.lchild.data
                node.lchild.rchild.nil? ? node.lchild = nil : node.lchild = node.lchild.rchild
            # if 2 children
            elsif !node.lchild.nil? && !node.rchild.nil?
                greatest_child = find_greatest_child(node.lchild)
                node.data = greatest_child.data
                greatest_child.lchild.nil? ? greatest_child = nil : greatest_child.parent.rchild = greatest_child.lchild
            end
        end
    end

    def find(value, node = @root)
        return node if node.data == value
        find(value, node.lchild) if !node.lchild.nil?
        find(value, node.rchild) if !node.rchild.nil?
    end

    def level_order(node = @root, q = [])
        return nil if node.nil?
        q << node
        while q.length >= 1
            current = q.shift()
            yield(current)
            q << current.lchild if !current.lchild.nil?
            q << current.rchild if !current.rchild.nil?
        end
    end

    def inorder(node = @root)
        return nil if node.nil?
        inorder(node.lchild)
        puts node.data 
        inorder(node.rchild)
    end

    def preorder(node = @root)
        return nil if node.nil?
        puts node.data
        preorder(node.lchild) 
        preorder(node.rchild)
    end

    def postorder(node = @root)
        return nil if node.nil?
        postorder(node.lchild) 
        postorder(node.rchild)
        puts node.data
    end

    def depth(node = @root)
        return -1 if node.nil?
        left_depth = depth(node.lchild)
        right_depth = depth(node.rchild)
        left_depth > right_depth ? max = left_depth : max = right_depth
        max+1
    end

    def balanced?(node = @root)
        return nil if node.nil?
        left_depth = depth(node.lchild)
        right_depth = depth(node.rchild)

        answer = left_depth - right_depth > 1 || left_depth - right_depth < -1 ? false : true
        answer
    end

    def rebalance!(node = @root)
        array = []
        self.level_order { |node| array << node.data }
        @root = self.build_tree(array)
    end

end





tree = Tree.new(Array.new(15) { rand(1..100) })

pp tree

# node = tree.find(6345)
# pp node

tree.level_order { |node| puts node.data }
puts "Level Order ^"
puts ""
puts "In Order ^ #{tree.inorder}"
puts ""
puts "Pre Order ^ #{tree.preorder}"
puts ""
puts "Post Order ^ #{tree.postorder}"

puts "Depth: #{tree.depth}"
puts "Balanced? #{tree.balanced?}"
puts ""

tree.insert(6666)
tree.insert(7000)
tree.insert(8500)
tree.insert(9000)
tree.insert(11111)
puts "Added values"
puts "Depth: #{tree.depth}"
puts "Balanced? #{tree.balanced?}"
puts ""

tree.rebalance!
puts "Rebalanced"
puts "Level Order ^"
puts ""
puts "In Order ^ #{tree.inorder}"
puts ""
puts "Pre Order ^ #{tree.preorder}"
puts ""
puts "Post Order ^ #{tree.postorder}"

puts ""
puts "Depth: #{tree.depth}"
puts "Balanced? #{tree.balanced?}"