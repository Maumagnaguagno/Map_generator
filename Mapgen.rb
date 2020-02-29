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

  SIZE = 10
  SEED = 4
  ROOM = 1
  SLEEP = 0.02

  #-----------------------------------------------
  # Maze division
  #-----------------------------------------------

  def maze_division(width = SIZE, height = width, room_size = ROOM, sleep_time = nil)
    grid = Array.new(height) {Array.new(width, 0)}
    return grid if width <= room_size or height <= room_size or room_size <= 0
    parts = [0, 0, width, height]
    while height = parts.pop
      width = parts.pop
      y = parts.pop
      x = parts.pop
      if sleep_time
        display_maze(grid)
        sleep(sleep_time)
      end
      if width != height ? width < height : rand(2).zero?
        wy = y + h = rand(height - room_size)
        passage = x + rand(width)
        x.upto(x + width.pred) {|wx| grid[wy][wx] |= 1 if wx != passage}
        parts.push(x, y, width, h) if room_size < h += 1
        parts.push(x, wy.succ, width, height) if room_size < height -= h
      else
        wx = x + w = rand(width - room_size)
        passage = y + rand(height)
        y.upto(y + height.pred) {|wy| grid[wy][wx] |= 2 if wy != passage}
        parts.push(x, y, w, height) if room_size < w += 1
        parts.push(wx.succ, y, width, height) if room_size < width -= w
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
    bottom = ' '
    grid.each_with_index {|row,y|
      grid_str << "\n|"
      bottom = '_' if y == height
      row.each_with_index {|cell,x|
        grid_str << (cell.odd? ? '_' : bottom)
        grid_str << (cell > 1 || x == width ? '|' : ((cell & row[x.succ]).odd? ? '_' : bottom))
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
      map.push(walls = [tile_wall], ground = [tile_wall])
      row.each_with_index {|cell,x|
        south = cell.odd? || bottom ? tile_wall : tile_clear
        if cell > 1 or x == width
          walls.push(tile_clear, tile_wall)
          ground.push(south, tile_wall)
        else
          walls.push(tile_clear, tile_clear)
          ground.push(south, south)
        end
      }
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
      puts "Mapgen [width=#{Mapgen::SIZE}] [height=width] [room_size=#{Mapgen::ROOM}] [seed=#{Mapgen::SEED}] [sleep=#{Mapgen::SLEEP}]"
    else
      # Arguments
      width     = ARGV[0] ? ARGV[0].to_i : Mapgen::SIZE
      height    = ARGV[1] ? ARGV[1].to_i : width
      room_size = ARGV[2] ? ARGV[2].to_i : Mapgen::ROOM
      seed      = ARGV[3] ? ARGV[3].to_i : Mapgen::SEED
      sleep     = ARGV[4] ? ARGV[4].to_f : Mapgen::SLEEP
      srand(seed)
      # Execute
      t = Time.now.to_f
      print "\e[2J"
      map = Mapgen.maze_division(width, height, room_size, sleep.zero? ? nil : sleep)
      Mapgen.display_maze(map)
      map_tile = Mapgen.wall_to_tile(map, ' ', '#')
      puts Time.now.to_f - t, "Mapgen #{width} #{height} #{room_size} #{seed} #{sleep}", map.map! {|row| row.join}, map_tile.map! {|row| row.join}
    end
  rescue
    puts $!, $@
  end
end