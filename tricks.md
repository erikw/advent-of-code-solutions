# Advent of Code Tricks
Some collected tricks after solving the puzzles.

## Input Parsing
* Integer scanning
  * If the input are just integers, instead of parsing or using a complex regex, just scan each integer.
  * Example of input: a list of coordinates
   ```ruby
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
   ```
  * Then just:
   ```ruby
    input = ARGF.each_line.map do |line|
		  line.scan(/-?\d+/).map(&:to_i)
		end
   ```
  * Examples: [2018/10](2018/10/part1.rb)
* Load as YAML
  * Does the input look like YAML? Massage it an load it!
  * Examples [2017/25](https://www.reddit.com/r/adventofcode/comments/7lzo3l/comment/drqk1wu/)

## Testing
### Performance testing
Typically you will have seveal competing ideas, implementation and data structures for your solution. Big-o-theory is one thing, reality might be another. It's easy tog get some runtime stats with `time(1)`. However just a single run is not reliable to make a call about the performance. You need to run it multiple times and take an average. This is where the exellent program [`multitime(1)`](https://tratt.net/laurie/src/multitime/) comes in! Just give it the number of times it should execute your program and it will give you the time stats:

```console
$ multitime -n 5 ./part2.rb input  # Here running solution for 2019/24 for my input.
2031
2031
2031
2031
2031
===> multitime results
1: ./part2.rb input
            Mean        Std.Dev.    Min         Median      Max
real        12.623      1.343       11.405      12.093      14.958
user        11.808      0.817       11.032      11.640      13.282
sys         0.284       0.051       0.239       0.248       0.369
```

Now just do the same with your alternative soltuion and compare!

### File naming
The problem instructions often includes several examples with expected results. Sometimes directly and some times after a few hand-calculations. To make the solution development easier to develop and test, save these in some files. The convention that I've landed in is
* `input` - the raw input `curl(1)`'d from the website
* `input1.X` - Input example number X for part 1
* `output1.X` - Output expected for `input1.X`
* `input2.X` - Input example number X for part 2
* `output2.X` - Output expected for `input2.X`

Being precise and following this convention, it's now super easy to run all tests for one part. Let's say there were 4 examples for part 1, then we can simply do (an old trick from a University professor in algorithms that I had) in a Bourne-like shell:
```console
$ for i in {0..4}; do ./part1.rb input1.$i | diff -y - output1.$i; done
31                 31
165             |  168
13312           |  23312
180697             180697
2210736            2210736
```

to get side-by-side comparison between expected (column 1) and actual (column 2)! In the above example, two test cases were wrong.

## Grids
* Complex Numbers
  * For two-dimensional grids, using complex numbers x+yi instead of (x,y) can be beneficial
  * Looking at neighbours by applying a delta is easy:
   ```ruby
      NEIGHBOURS_DELTAS = [-1, 1, -1i, 1i]
      pos = 1 + 2i
      NEIGHBOURS_DELTAS.each do |delta|
        pos_neighbour = pos + delta
        ...
      end
   ```
  * Storing a direction is just the numbers `-1, +1i, +1, -1i` instead of up/right/down/left or north/east/south/west. Rotating the direction is just multiplying with `-1i` (clockwise) or `+1i` (counter-clockwise). In this example `x == real == row` and `y == imag == col`. When x and y are swapped, the rotation goes in the other direction.
   ```ruby
      position = 5 + 7j
      direction = 1i

      direction *= 1i
      position += direction
   ```
  * Examples:[2020/2](2020/12/part1.rb), [2018/13](2018/13/part1_complex.rb), [2018/22](2018/22/), [2019/03](2019/03/part1_complex.rb), [2019/11](2019/11/part1.rb)
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
  * Instead of spending time in a grid to discover all nodes (cells) before Dijkstra as its input, instead add new nodes as they are discovered. If you're lucky, some time could be saved but not considering all cells.
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
