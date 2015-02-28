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
# - Using a iterative mode to speed up
# - Using shift instead of pop to emulate recursion/stack behavior
# - Using string as buffer to achieve faster single print
# - Added wall to tile conversion system
#-----------------------------------------------
# TODOs
# - Tests
#-----------------------------------------------

module Mapgen
  extend self

  SOUTH = 1
  EAST = 2
  SLEEP = 0.02 # Use nil to avoid waits

  #-----------------------------------------------
  # Display maze
  #-----------------------------------------------

  def display_maze(grid)
    print "\e[H\r"
    grid_str = '_' * (grid.first.size << 1).succ
    height = grid.size.pred
    width = grid.first.size.pred
    grid.each_with_index {|row, y|
      grid_str << "\n|"
      bottom = y == height
      row.each_with_index {|cell, x|
        south = (cell & SOUTH != 0 || bottom)
        right = x == width
        grid_str << (south ? '_' : ' ')
        grid_str << (cell >= EAST || right ? '|' : ((south && (!right && row[x.succ] & SOUTH != 0 || bottom)) ? '_' : ' '))
      }
    }
    sleep(SLEEP) if SLEEP
    puts grid_str
  end

  #-----------------------------------------------
  # Maze division
  #-----------------------------------------------

  def maze_division(width, height, room_size = 1, display_steps = false)
    raise 'Zero-sized dimension' if width.zero? or height.zero?
    grid = Array.new(height) {Array.new(width, 0)}
    parts = [0, 0, width, height]
    until parts.empty?
      x, y, width, height = parts.pop(4)
      next if width <= room_size or height <= room_size
      display_maze(grid) if display_steps
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
    display_maze(grid) if display_steps
    grid
  end

  #-----------------------------------------------
  # Wall to tile
  #-----------------------------------------------

  def wall_to_tile(grid, tile_clear = 0, tile_wall = 1)
    map = [Array.new((grid.first.size << 1).succ, tile_wall)]
    height = grid.size.pred
    width = grid.first.size.pred
    grid.each_with_index {|row, y|
      bottom = y == height
      walls = [tile_wall]
      ground = [tile_wall]
      row.each_with_index {|cell, x|
        south = (cell & SOUTH != 0 || bottom)
        right = x == width
        if cell >= EAST or right
          walls << tile_clear << tile_wall
          ground << (south ? tile_wall : tile_clear) << tile_wall
        else
          walls << tile_clear << tile_clear
          if south and (not right or row[x.succ] & SOUTH != 0 or bottom)
            ground << tile_wall << tile_wall
          else
            ground << (south ? tile_wall : tile_clear) << tile_clear
          end
        end
=begin
        walls << tile_clear
        case cell
        when 0
          ground << tile_clear
          walls << tile_clear
        when 1
          ground << tile_wall
          walls << tile_clear
        when 2
          ground << tile_clear
          walls << tile_wall
          ground << tile_wall
        when 3
          ground << tile_wall
          walls << tile_wall
          ground << tile_wall
        end
=end
      }
      map << walls << ground
    }
    map
  end
end

#-----------------------------------------------
# Main
#-----------------------------------------------

if $0 == __FILE__
  begin
    # Arguments
    width = (ARGV[0] || 10).to_i
    height = (ARGV[1] || width).to_i
    room_size = (ARGV[2] || 1).to_i
    seed = (ARGV[3] || rand(0xFFFFFFFF)).to_i
    srand(seed)
    # Run
    t = Time.now.to_f
    print "\e[2J"
    map = Mapgen.maze_division(width, height, room_size, true)
    map_tile = Mapgen.wall_to_tile(map, ' ', '#')
    puts "#$0 #{width} #{height} #{room_size} #{seed}"
    puts Time.now.to_f - t
    puts map.map {|row| row.join}.join("\n")
    puts map_tile.map {|row| row.join}.join("\n")
  rescue
    puts $!, $@
    STDIN.gets
  end
end