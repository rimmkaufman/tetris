# core.rb

class Hash
  def remap(hash={})
    each {|k,v| yield hash, k,v}
    hash
  end
end

class Array

  def self.new2d (rows, cols)
    self.new(rows).map! {self.new(cols) }
  end

  def rotate_left
    _rotate(self) { |x,i,j,m| x[j][m-1-i]}
  end

  def rotate_right
    _rotate(self) { |x,i,j,m| x[m-1-j][i]}
  end

  def random_element
    self[rand * self.length]
  end

  private

  def _rotate(x)
    m = x.length
    y = Array.new2d(m,m)
    for i in (0 .. m-1)
      raise 'bad shape' unless self[i].respond_to?(:length) && x[i].length == m
      for j in (0..m-1)
        y[i][j] = yield(x,i,j,m)
      end
    end
    y
  end

end

class Object
  def deep_clone
    Marshal::load(Marshal.dump(self))
  end
end
