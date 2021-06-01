# Map generator [![Actions Status](https://github.com/Maumagnaguagno/Map_generator/workflows/build/badge.svg)](https://github.com/Maumagnaguagno/Map_generator/actions)
**Map generator for the lazy game designer**

An implementation of the **Recursive Division** algorithm for maze generation, using an iterative approach instead.
Added wall to tile conversion method to use with tile based engines.
The code was adapted from [The Buckblog](http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm), the original code is in this [gist](https://gist.github.com/jamis/761525).

<p align="center">
<img src="https://cloud.githubusercontent.com/assets/11094484/14408449/e29d9948-fecb-11e5-823a-0573234b549e.gif" alt="Animation with execution commands"/>
</p>

## Execution
- Execute terminal (ANSI support) with default configurations or user provided values
```Shell
ruby Mapgen.rb [width=10] [height=width] [room_size=1] [seed=4] [sleep=0.02]
```

- Execute tests
```Shell
ruby test_mapgen.rb
```

## Map representation
Although maps of MxN cells are internally represented by a MxN structure, they can be displayed in different ways.
Each cell may contain walls to their bottom and right sides, yielding 4 cases:
- 0: No walls
- 1: Bottom
- 2: Right
- 3: Bottom and right

Using ``Mapgen 4 4 1 4 0.02`` one will obtain the following map with all 4 cases:

```
1210
0101
1310
0000
```

``display_maze`` uses spaces, pipes and underscores to represent clear or walled cells.
As some cells can have both bottom and right walls, ``_|``, they require twice the amount of characters to be represented.
The outer walls add one extra top row and left collumn, rendering (2M+1)x(N+1) maps.

```
_________
|_  |_  |
|  _   _|
|___|_  |
|_______|
```

``wall_to_tile`` converts both cells and walls to different tiles, creating 4 tiles for each cell and an extra row and collumn of cells.
This happens due to the walls between each N cells also becoming tiles (N-1 walls) plus outer border walls (2), rendering: (2M+1)x(2N+1) tile maps.

```
(N cells) + (N-1 walls) + (2 walls) = 2N + 1 tiles
```

```
#########
#   #   #
### ### #
#       #
#  ##  ##
#   #   #
####### #
#       #
#########
```

This also means these two display formats will have odd dimensions and borders around the entire map.
This may be good (no limit checking) or bad (ugly dimensions, no toroidal map support).

## Projects using Map generator
- [x3030](https://github.com/pravj/x3030): Maze game for Google Chrome based on [that bug](https://code.google.com/p/chromium/issues/detail?id=533361).

Feel free to use Map generator in your projects and send me a link to add here.