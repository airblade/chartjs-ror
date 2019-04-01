module Chartjs
  @@no_conflict = false
  @@disable_css_injection = false

  def self.no_conflict!
    @@no_conflict = true
  end

  def self.no_conflict
    @@no_conflict
  end

  def self.disable_css_injection!
    @@disable_css_injection = true
  end

  def self.disable_css_injection
    @@disable_css_injection
  end
end

require 'chartjs/engine'
require "chartjs/version"
