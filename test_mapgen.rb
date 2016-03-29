require 'test/unit'
require './mapgen_iterative_division'

class Test_Mapgen < Test::Unit::TestCase
 
  def test_dimensions
    max = 20
    1.upto(max) {|height|
      expected_height = (height << 1).succ
      1.upto(max) {|width|
        expected_width = (width << 1).succ
        map = Mapgen.maze_division(width, height, 2)
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
    map = Mapgen.maze_division(20, 20, 2)
    map_tile = Mapgen.wall_to_tile(map, clear, wall)
    map_tile.each {|row|
      row.each {|cell|
        assert_kind_of(Fixnum, cell)
        assert(cell == clear || cell == wall)
      }
    }
  end

  def test_default_map
    srand(Mapgen::SEED)
    map = Mapgen.maze_division
    map_tile = Mapgen.wall_to_tile(map, ' ', '#')
    assert_equal(
      ['1220210111',
       '1122322120',
       '2022220200',
       '0311103131',
       '2012212210',
       '2222203011',
       '2130301111',
       '1111301111',
       '0100120020',
       '0220202200'],
      map.map {|row| row.join}
    )
    assert_equal(
      ['#####################',
       '#   # #   #         #',
       '### # #   ###  ######',
       '#     # # # # #   # #',
       '##### # ### # ### # #',
       '# #   # # # #   #   #',
       '# #   # # # #   #   #',
       '#   #         #   # #',
       '#  ########  ########',
       '# #     # #   # #   #',
       '# #  ## # ### # ### #',
       '# # # # # #   #     #',
       '# # # # # #  ##  ####',
       '# #   #   #         #',
       '# #####  ##  ########',
       '#         #         #',
       '###########  ########',
       '#           #     # #',
       '#  ##    ## #     # #',
       '#   # #   #   # #   #',
       '#####################'],
      map_tile.map {|row| row.join}
    )
  end
end