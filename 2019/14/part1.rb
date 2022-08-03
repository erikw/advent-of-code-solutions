#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib'

inv_reactions = inv_reactions_from_input
puts fuel_cost(inv_reactions, 1)
