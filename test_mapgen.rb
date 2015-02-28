require 'test/unit'
require './mapgen_iterative_division'

class Test_Mapgen < Test::Unit::TestCase
 
  def test_dimensions
    room_size = 2
    max = 20
    1.upto(max) {|height|
      expected_height = (height << 1).succ
      1.upto(max) {|width|
        expected_width = (width << 1).succ
        map = Mapgen.maze_division(width, height, room_size)
        map_tile = Mapgen.wall_to_tile(map)
        assert_kind_of(Array, map_tile)
        assert_equal(map_tile.size, expected_height)
        map_tile.each {|row|
          assert_kind_of(Array, row)
          assert_equal(row.size, expected_width)
        }
      }
    }
  end

  def test_cells
    clear = 0
    wall = 1
    width = height = 20
    room_size = 2
    map = Mapgen.maze_division(width, height, room_size)
    map_tile = Mapgen.wall_to_tile(map, clear, wall)
    map_tile.each {|row|
      row.each {|cell|
        assert_kind_of(Fixnum, cell)
        assert(cell == clear || cell == wall)
      }
    }
  end
end