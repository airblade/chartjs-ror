require 'chartjs/chart_helpers'
require 'chartjs/axis_helpers'

module Chartjs
  class Engine < Rails::Engine
    initializer 'chartjs.chart_helpers' do
      ActionView::Base.send :include, Chartjs::ChartHelpers

      unless ::Chartjs.no_conflict
        ActionView::Base.class_eval do
          %w[ line bar radar polar_area pie doughnut ].each do |type|
            alias :"#{type}_chart" :"chartjs_#{type}_chart"
          end
        end
      end

      ActionView::Base.send :include, Chartjs::AxisHelpers
    end
  end
end
