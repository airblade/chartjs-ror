require 'chartjs/chart_helpers'
require 'chartjs/axis_helpers'

module Chartjs
  class Engine < Rails::Engine
    initializer 'chartjs.chart_helpers' do
      ActionView::Base.send :include, Chartjs::ChartHelpers
      ActionView::Base.send :include, Chartjs::AxisHelpers
    end
  end
end
