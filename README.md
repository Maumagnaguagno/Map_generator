# Map generator [![Build Status](https://travis-ci.org/Maumagnaguagno/Map_generator.svg)](https://travis-ci.org/Maumagnaguagno/Map_generator)
**Map generator for the lazy game designer**

- Adapted from http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm
- Original https://gist.github.com/jamis/761525

An implementation of the **Recursive Division** algorithm for maze generation, using an iterative approach instead.
Added wall to tile conversion method to use with tile based engines.

### Execution
![mapgen](https://cloud.githubusercontent.com/assets/11094484/14408412/702b6b70-feca-11e5-8d15-052cdd597ebc.gif)

- Execute terminal (ANSI support) with default configurations or user provided values
```
ruby Mapgen.rb [width=10] [height=width] [room_size=1] [seed=4] [sleep=0.02]
```
- Execute tests
```
ruby test_mapgen.rb
```

### Dimensions
Maps have ```2 * N + 1``` size for N being width or height, therefore asking a 10x10 map yields a 21x21 tile-based one.
This happens due to the walls between each cell (N-1 walls between them) plus 2 border walls, therefore we have:
```
(N cells) + (N-1 walls) + (2 walls) = N + N - 1 + 2 = 2 * N + 1 tiles
```

This also means all maps generated will have odd dimensions and borders around the entire map.
This may be good (no limit checking) or bad (ugly dimensions, no toroidal map support)