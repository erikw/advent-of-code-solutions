# Advent of Code Tricks
Some collected tricks after solving the puzzles.

## Input Parsing
* Integer scanning
  * If the input are just integers, instead of parsing or using a complex regex, just scan each integer.
  *
   ```ruby
		line.scan(/-?\d+/).map(&:to_i)
   ``` 
  * Examples: [2018/10](2018/10/part1.rb)
* Load as YAML
  * Does the input look like YAML? Massage it an load it!
  * Examples [2017/25](https://www.reddit.com/r/adventofcode/comments/7lzo3l/comment/drqk1wu/)


## Grids
* Complex Numbers
  * For two-dimensional grids, using complex numbers x+yi instead of (x,y) can be beneficial
  * Looking at neighbours by applying a delta is easy:
   ```ruby
      NEIGHBORS_DELTAS = [-1, 1, -1i, 1i]
      NEIGHBORS_DELTAS.each do |delta|
        pos_neighbour = pos + delta
        ...
      end
   ``` 
  * Storing a direction is just the numbers `-1, +1i, +1, -1i` instead of up/right/down/left or north/east/south/west. Rotating the direction is just multiplying with `-1i`` (clockwise) or `+1i`` (counter-clockwise). In this example `x == real == row` and `y == imag == col`. When x and y are swapped, the rotation goes in the other direction.
   ```ruby
      position = 5 + 7j
      direction = 1i

      direction *= 1i
      position += direction
   ``` 
  * Examples: [2018/13](2018/13/part1_complex.rb), [2018/22](2018/22/)
* Cell neighbours
  * When needing to check/recurse on all neighbhours of a cell (e.g including diagonal neighbours), just loop on the deltas:
  *
   ```ruby
    [-1, 0, 1].each do |dx|
      [-1, 0, 1].each do |dy|
        if grid[x + dx][y + dy] == ...
        end
      end
   end
   ``` 
  * Examples: [2018/18](2018/18/lib.rb)



## Algorithms
* Dijkstra's Algorithm
  * Instead of spending time in a grid to discover all nodes (cells) before Dijkstra as it is input, instead add new nodes as they are discovered. If you're lucky, some time could be saved but not considering all cells.
  * Examples: [2018/15](2018/15/game.rb)


## Misc
* Constraint solver
  * Is the problem too hard to solve? Let someone else do it: [Z3](https://github.com/Z3Prover/Z3).
  * Examples: [2018/10](2018/23/part2.rb)

## Ruby
* throw-catch
  * Break out of nested code with throw and catch [SO](https://stackoverflow.com/a/3716921/265508).
  * Examples: [2018/13](2018/13/part1.rb), [2018/15](2018/15/game.rb)
* Deep cloning next state version 
  * In recursions that need a complete copy of a state, or when we iterate on something like a grid that needs to be updated in multiple steps using current values, make a complete copy of the state with deep cloining.
  *
   ```ruby
    5.times do
      map_next = Marshal.load(Marshal.dump(map))
      (0...map.length).each do |x|
        (0...map[0].length).each do |y|
          map_next[x][y] = something_with(map)
        end
      end

      map = map_next
  end
   ``` 
  * Examples: [2018/18](2018/18), [2015/18](2015/18/part1.rb)
