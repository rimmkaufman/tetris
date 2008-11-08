require 'test/unit'
require 'core'
require 'pp'

class CoreTest < Test::Unit::TestCase
  def test_hash_remap
  		h =  {:x => 1, 'x' => 2, 'foo' => 3}
  		h2 = {:x => 1, 'x'=>4, 'foo'=>9}
  		assert_equal h2, h.remap {|h,k,v| h[k]=v*v}, 'remap'
		end
	def test_new2d
		assert_equal  [[nil, nil, nil], [nil, nil, nil]], Array.new2d(2,3)
	end
	def test_rotateR
		a = [['a','b','c'],['d','e','f'],['h','i','j']]
		assert_equal [["h", "d", "a"], ["i", "e", "b"], ["j", "f", "c"]], a.rotate_right
		assert_equal [["c", "f", "j"], ["b", "e", "i"], ["a", "d", "h"]], a.rotate_left
		assert_raise(RuntimeError) {[1,2,3].rotate_left}
		assert_raise(RuntimeError) {[[1],[2]].rotate_left}
	end
	def test_deep_clone
		x=[[1,2,3],[4,5,6]]
		y=x
		assert_equal y,x
		y[1][1]='fish'
		assert_equal y,x
		z = x.deep_clone
		assert z,x
		z[0][0] = 'cake'
		assert_not_equal z,x
		assert_equal [['cake',2,3],[4,'fish',6]], z
	end
	def test_random_element
		x = [1,2,3,'apple']
		freq	= Hash.new(0)
		100.times do
			pick = x.random_element 
			assert x.member?(pick), "#{x.inspect} contains #{pick}"
			freq[pick] += 1
		end
		assert_equal x.length, freq.keys.length
	end
end