module Chartjs
  @@no_conflict = false

  def self.no_conflict!
    @@no_conflict = true
  end

  def self.no_conflict
    @@no_conflict
  end
end

require 'chartjs/engine'
require "chartjs/version"
