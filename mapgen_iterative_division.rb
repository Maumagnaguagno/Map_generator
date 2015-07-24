#!/usr/bin/env ruby
#-----------------------------------------------
# Mapgen Iterative division
#-----------------------------------------------
# Mau Magnaguagno
#-----------------------------------------------
# Map generator for the lazy game designer
#-----------------------------------------------
# Adapted from
# http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm
#-----------------------------------------------
# Feb 2015
# - Created
# - Iterative mode to speed up
# - Emulate recursion with stack behavior
# - String as buffer to achieve faster print
# - Added wall to tile conversion system
# Apr 2015
# - Moved sleep time constant to an argument
# Jul 2015
# - Sleep time is an argument of maze_division
# - Simplified conditions
#-----------------------------------------------

module Mapgen
  extend self

  SOUTH = 1
  EAST = 2

  #-----------------------------------------------
  # Maze division
  #-----------------------------------------------

  def maze_division(width, height, room_size = 1, sleep_time = nil)
    raise 'Zero-sized dimension' if width.zero? or height.zero? or room_size.zero?
    grid = Array.new(height) {Array.new(width, 0)}
    parts = [0, 0, width, height]
    until parts.empty?
      x, y, width, height = parts.pop(4)
      next if width <= room_size or height <= room_size
      if sleep_time
        display_maze(grid)
        sleep(sleep_time)
      end
      if width != height ? width < height : rand(2).zero?
        h = rand(height - room_size)
        wy = y + h
        passage = x + rand(width)
        x.upto(x + width.pred) {|wx| grid[wy][wx] |= SOUTH if wx != passage}
        h += 1
        parts.push(x, y, width, h, x, wy.succ, width, height - h)
      else
        w = rand(width - room_size)
        wx = x + w
        passage = y + rand(height)
        y.upto(y + height.pred) {|wy| grid[wy][wx] |= EAST if wy != passage}
        w += 1
        parts.push(x, y, w, height, wx.succ, y, width - w, height)
      end
    end
    grid
  end

  #-----------------------------------------------
  # Display maze
  #-----------------------------------------------

  def display_maze(grid)
    print "\e[H\r"
    grid_str = '_' * (grid.first.size << 1).succ
    height = grid.size.pred
    width = grid.first.size.pred
    grid.each_with_index {|row,y|
      grid_str << "\n|"
      bottom = y == height
      row.each_with_index {|cell,x|
        south = (cell & SOUTH != 0 || bottom)
        grid_str << (south ? '_' : ' ')
        grid_str << (cell >= EAST || x == width ? '|' : ((south && (row[x.succ] & SOUTH != 0 || bottom)) ? '_' : ' '))
      }
    }
    puts grid_str
  end

  #-----------------------------------------------
  # Wall to tile
  #-----------------------------------------------

  def wall_to_tile(grid, tile_clear = 0, tile_wall = 1)
    map = [Array.new((grid.first.size << 1).succ, tile_wall)]
    height = grid.size.pred
    width = grid.first.size.pred
    grid.each_with_index {|row,y|
      bottom = y == height
      walls = [tile_wall]
      ground = [tile_wall]
      row.each_with_index {|cell,x|
        south = (cell & SOUTH != 0 || bottom)
        if cell >= EAST or x == width
          walls.push(tile_clear, tile_wall)
          ground.push(south ? tile_wall : tile_clear, tile_wall)
        else
          walls.push(tile_clear, tile_clear)
          if south
            ground.push(tile_wall, tile_wall)
          else
            ground.push(tile_clear, tile_clear)
          end
        end
      }
      map.push(walls, ground)
    }
    map
  end
end

#-----------------------------------------------
# Main
#-----------------------------------------------
if $0 == __FILE__
  begin
    # Help
    if ARGV.first == '-h'
      puts "#$0 [width=10] [height=width] [room_size=1] [seed=rand(0xFFFFFFFF)] [sleep=0.02]"
    else
      # Arguments
      width = (ARGV[0] || 10).to_i
      height = (ARGV[1] || width).to_i
      room_size = (ARGV[2] || 1).to_i
      seed = (ARGV[3] || rand(0xFFFFFFFF)).to_i
      sleep = ARGV[4] ? ARGV[4].to_f : 0.02
      srand(seed)
      # Execute
      t = Time.now.to_f
      print "\e[2J"
      map = Mapgen.maze_division(width, height, room_size, sleep.zero? ? nil : sleep)
      Mapgen.display_maze(map)
      map_tile = Mapgen.wall_to_tile(map, ' ', '#')
      puts Time.now.to_f - t, "#$0 #{width} #{height} #{room_size} #{seed} #{sleep}"
      puts map.map {|row| row.join}, map_tile.map {|row| row.join}
    end
  rescue
    puts $!, $@
    STDIN.gets
  end
end