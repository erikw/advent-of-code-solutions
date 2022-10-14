# frozen_string_literal: true

# The flipped tile's edges represent can always be flipped to the other side
# => it's enough to save one edge and always select on the min one.
def edge_id(edge)
  [edge, edge.reverse].min
end

def edges_of(tile)
  north = tile[0]
  east = tile.map(&:last)
  south = tile[-1]
  west = tile.map(&:first)

  north_r = north.reverse
  east_r = east.reverse
  south_r = south.reverse
  west_r = west.reverse

  { north: edge_id(north), east: edge_id(east),
    south: edge_id(south), west: edge_id(west) }
end

def edges_of_real(tile)
  north = tile[0]
  east = tile.map(&:last)
  south = tile[-1]
  west = tile.map(&:first)

  { north:, east:,
    south:, west: }
end

def read_input
  tiles = {} # tile_nbr -> [tile_edges array, tile img array]
  edges = Hash.new { |h, k| h[k] = [] } # border array -> tile_nbr TODO make inner array a set?
  ARGF.readlines.join.split("\n\n").map(&:lines).each do |header, *tile|
    nbr = header.scan(/\d+/)[0].to_i
    tile = tile.map { |l| l.chomp.chars }
    tiles[nbr] = tile
    tile_edges = edges_of(tile)

    tile_edges.each_value do |dir|
      edges[dir] << nbr
    end
  end
  [tiles, edges]
end

def nbr_compatible_sides(tiles, edges, tile_nbr)
  tile = tiles[tile_nbr]
  tile_edges = edges_of(tile)

  edges_adj = tile_edges.values.count do |dir|
    edges[dir].length > 1
  end
end

# Assumption: each edge is unique and the corner tiles will only have overlapping edges with two other sides.
#             Then it's just finding the tiles that are only sharing edge with with two other tiles.
def find_corner_tiles(tiles, edges)
  tiles.keys.select do |nbr|
    nbr_compatible_sides(tiles, edges, nbr) == 2
  end
end
