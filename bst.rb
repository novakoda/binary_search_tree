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

    def level_order(node = @root, q = [], &block)
        q << node
        level_order(node.lchild, q, &block) if !node.lchild.nil?
        level_order(node.rchild, q, &block) if !node.rchild.nil?
        current = q.shift()
        yield(current)
    end


end





tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts tree.root.data
pp tree
tree.delete(8)
puts tree.root.data
pp tree

# node = tree.find(6345)
# pp node

tree.level_order { |node| puts node.data }