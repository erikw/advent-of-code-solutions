# frozen_string_literal: true

SYM_CLAY = '#'
SYM_SAND = '.'
SYM_WATER_FLOW = '|'
SYM_WATER_REST = '~'
SYM_WATER_SRC = '+'
SYMS_OPEN = [SYM_SAND, SYM_WATER_FLOW]

WATER_SRC_CORD = [500, 0]

def read_map
  map = Hash.new('.')
  map[[WATER_SRC_CORD[0], WATER_SRC_CORD[1] - 1]] = SYM_WATER_FLOW
  ARGF.each_line do |line|
    match = line.match(/([xy])=(\d+), ([xy])=(\d+)\.\.(\d+)/)
    axis1 = match[1]
    axis1_val = match[2].to_i
    axis2 = match[3]
    axis2_val1 = match[4].to_i
    axis2_val2 = match[5].to_i
    (axis2_val1..axis2_val2).each do |val|
      cord = axis1 == 'x' ? [axis1_val, val] : [val, axis1_val]
      map[cord] = SYM_CLAY
    end
  end
  map
end

def print_map(map)
  puts '=' * 20
  xmin, xmax = map.keys.map(&:first).minmax
  ymin, ymax = map.keys.map(&:last).minmax

  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      print map[[x, y]]
    end
    puts
  end
end

def flood(map, x, y, step, ymax)
  flow = nil
  if map[[x, y]] != SYM_CLAY && map[[x, y + 1]] == SYM_WATER_FLOW && map[[x, y - 1]] == SYM_WATER_FLOW
    flow = :flow_inf
    map[[x, y]] = SYM_WATER_FLOW
  else
    while map[[x, y]] == SYM_SAND &&
          flow != :flow_inf &&
          (![SYM_SAND, SYM_WATER_FLOW].include?(map[[x - step, y + 1]]) || map[[x, y - 1]] == SYM_WATER_FLOW)
      map[[x, y]] = SYM_WATER_FLOW
      flow = drop_water(map, x, y + 1, ymax) if map[[x, y + 1]] == SYM_SAND

      x += step
    end
    flow = :flow_inf if map[[x, y]] == SYM_WATER_FLOW
  end
  [[x - step, y], flow]
end

def drop_water(map, x, y, ymax)
  if y > ymax
    :flow_inf
  else
    last_flow_left, flow_left = flood(map, x, y, -1, ymax)
    last_flow_right, flow_right = flood(map, x + 1, y, 1, ymax)
    if flow_left == :flow_inf || flow_right == :flow_inf
      :flow_inf
    else
      (last_flow_left[0]..last_flow_right[0]).each do |x_fill|
        map[[x_fill, y]] = SYM_WATER_REST
      end
      :flow_filled
    end
  end
end
