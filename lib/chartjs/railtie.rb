require 'chartjs/chart_helpers'

module Chartjs
  class Railtie < Rails::Railtie
    initializer 'chartjs.chart_helpers' do
      ActionView::Base.send :include, Chartjs::ChartHelpers
    end
  end
end
