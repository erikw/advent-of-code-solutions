#!/usr/bin/env ruby

SENSORS = [
  {
    path: '########.',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: true,
    e: true,
    f: true,
    g: true,
    h: true,
    i: false
  },
  {
    path: '#######.#',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: true,
    e: true,
    f: true,
    g: true,
    h: false,
    i: true
  },
  {
    path: '######.##',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: true,
    e: true,
    f: true,
    g: false,
    h: true,
    i: true
  },
  {
    path: '#####.###',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: true,
    e: true,
    f: false,
    g: true,
    h: true,
    i: true
  },
  {
    path: '####.####',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: true,
    e: false,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '###.#####',
    exp: false,
    a: true,
    b: true,
    c: true,
    d: false,
    e: true,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '##.######',
    exp: true,
    a: true,
    b: true,
    c: false,
    d: true,
    e: true,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '#.#######',
    exp: true,
    a: true,
    b: false,
    c: true,
    d: true,
    e: true,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '.########',
    exp: true,
    a: false,
    b: true,
    c: true,
    d: true,
    e: true,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '.#..#####',
    exp: false,
    a: false,
    b: true,
    c: false,
    d: false,
    e: true,
    f: true,
    g: true,
    h: true,
    i: true
  },
  {
    path: '...####..',
    exp: true,
    a: false,
    b: false,
    c: false,
    d: true,
    e: true,
    f: true,
    g: true,
    h: false,
    i: false
  },
  {
    path: '.#.#..###',
    exp: true,
    a: false,
    b: true,
    c: false,
    d: true,
    e: false,
    f: false,
    g: true,
    h: true,
    i: true
  },
  {
    path: '##.#.#..#',
    exp: false,
    a: true,
    b: true,
    c: false,
    d: true,
    e: false,
    f: true,
    g: false,
    h: false,
    i: true
  }
]

SENSORS.each do |p|
  # act = (!p[:a] || !p[:b] || !p[:c]) && p[:d] && (p[:h] || p[:e] && p[:i] || p[:e] && p[:f])
  act = !(p[:a] && p[:b] && p[:c]) && p[:d] && (p[:h] || p[:e] && (p[:i] || p[:f]))
  errmsg = ''
  errmsg = "\tWRONG: #{p[:path]}" if p[:exp] != act
  puts "exp: #{p[:exp]},\tact: #{act}#{errmsg}"
end
