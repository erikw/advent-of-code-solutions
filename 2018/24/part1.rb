#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

groups = parse_input
puts battle(groups)[0]
