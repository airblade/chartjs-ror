require 'chartjs/chart_helpers'

module Chartjs
  class Engine < Rails::Engine
    initializer 'chartjs.chart_helpers' do
      if ::Chartjs.no_conflict
        ActionView::Base.send :include, Chartjs::ChartHelpers::Explicit
      else
        ActionView::Base.send :include, Chartjs::ChartHelpers::Implicit
      end
    end
  end
end
