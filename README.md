# Map generator [![Build Status](https://travis-ci.org/Maumagnaguagno/Map_generator.svg)](https://travis-ci.org/Maumagnaguagno/Map_generator)
**Map generator for the lazy game designer**

An implementation of the **Recursive Division** algorithm for maze generation, using an iterative approach instead.
Added wall to tile conversion method to use with tile based engines.
The code was adapted from [Jamis Buck blog](http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm), the original code is in this [gist](https://gist.github.com/jamis/761525).
<p align="center">
<img src="https://cloud.githubusercontent.com/assets/11094484/14408449/e29d9948-fecb-11e5-823a-0573234b549e.gif" alt="Animation with execution commands"/>
</p>

## Execution
- Execute terminal (ANSI support) with default configurations or user provided values
```
ruby Mapgen.rb [width=10] [height=width] [room_size=1] [seed=4] [sleep=0.02]
```
- Execute tests
```
ruby test_mapgen.rb
```

## Dimensions
Maps have ``2 * N + 1`` size for N being width or height, therefore asking a 10x10 map yields a 21x21 tile-based one.
This happens due to the walls between each cell (N-1 walls between them) plus 2 border walls, therefore we have:
```
(N cells) + (N-1 walls) + (2 walls) = N + N - 1 + 2 = 2 * N + 1 tiles
```

This also means all maps generated will have odd dimensions and borders around the entire map.
This may be good (no limit checking) or bad (ugly dimensions, no toroidal map support).

## Projects using Map generator
- [x3030](https://github.com/pravj/x3030): Maze game for Google Chrome based on [that bug](https://code.google.com/p/chromium/issues/detail?id=533361).

Feel free to use Map generator in your projects and send me a link to put here.