# Map generator
[![Build Status](https://travis-ci.org/Maumagnaguagno/Map_generator.png)](https://travis-ci.org/Maumagnaguagno/Map_generator)
Map generator for the lazy game designers

Adapted from http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm
Original https://gist.github.com/jamis/761525

An implementation of the "Recursive Division" algorithm for maze generation, using an iterative approach instead.
Added wall to tile conversion method to use with tile based engines.

Maps have 2*N+1 for N being width or height, therefore asking a 10x10 map yields a 21x21 tile-based one.
This happens due to the walls between each cell (N-1 walls between them) plus 2 border walls, therefore we have:
(N cells) + (N-1 walls) + (2 walls) = N + N - 1 + 2 = 2 * N + 1 tiles

This also means all maps generated will have odd dimensions and borders around the entire map.
This may be good (no limit checking) or bad (ugly dimensions, not a toroidal map as pac-man)

I will try to add more features and a better test suite with webhooks
