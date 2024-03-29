require 'test/unit'
require 'stringio'
require './Mapgen'

class Test_Mapgen < Test::Unit::TestCase
 
  def test_dimensions
    max = 20
    1.upto(max) {|height|
      expected_height = height << 1 | 1
      1.upto(max) {|width|
        expected_width = width << 1 | 1
        map = Mapgen.maze_division(width, height, 2)
        map_tile = Mapgen.wall_to_tile(map)
        assert_instance_of(Array, map_tile)
        assert_equal(expected_height, map_tile.size)
        map_tile.each {|row|
          assert_instance_of(Array, row)
          assert_equal(expected_width, row.size)
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
        assert(cell.equal?(clear) || cell.equal?(wall))
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
      map.map!(&:join)
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
      map_tile.map!(&:join)
    )
  end

  def test_display_maze
    srand(Mapgen::SEED)
    $stdout = StringIO.new
    map = Mapgen.maze_division
    Mapgen.display_maze(map)
    assert_equal("\e[H\
_____________________
|_  | |   |_   _____|
|___  | |_| | |_  | |
| |   | | | |   |   |
|  _|_____   _|___|_|
| |  _  | |_  | |_  |
| | | | | |  _|  ___|
| |___|  _|  _______|
|_________|  _______|
|  _     _  |     | |
|___|_|___|___|_|___|
", $stdout.string)
  ensure
    $stdout = STDOUT
  end
end