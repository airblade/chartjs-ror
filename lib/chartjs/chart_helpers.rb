module Chartjs
  module ChartHelpers

    def line_chart(labels, datasets, options = {})
      chart 'Line', labels, datasets, options
    end

    def bar_chart(labels, datasets, options = {})
      chart 'Bar', labels, datasets, options
    end

    def radar_chart(labels, datasets, options = {})
      chart 'Radar', labels, datasets, options
    end

    def polar_area_chart(data, options = {})
      chart 'PolarArea', nil, data, options
    end

    def pie_chart(data, options = {})
      chart 'Pie', nil, data, options
    end

    def doughnut_chart(data, options = {})
      chart 'Doughnut', nil, data, options
    end

    private

    def chart(klass, labels, datasets, options)
      @chart_id ||= -1
      element_id = options.delete(:id)     || "chart-#{@chart_id += 1}"
      css_class  = options.delete(:class)  || 'chart'
      width      = options.delete(:width)  || '400'
      height     = options.delete(:height) || '400'

      canvas = content_tag(:canvas, id: element_id, width: width, height: height) do
      end

      # Alternative scale calculations.
      if options[:scaleOverride] && !options.has_key?(:scaleSteps)
        options.merge! ordinate_scale(combined_data(datasets))
      end

      script = javascript_tag do
        <<-END.squish.html_safe
        (function() {
          var initChart = function() {
            var data = #{data_for labels, datasets};
            var opts = #{options.to_json};
            if (!("animation" in opts)) {
              opts["animation"] = (typeof Modernizr == "undefined") || Modernizr.canvas;
            }
            var canvas = document.getElementById(#{element_id.to_json});
            var ctx = canvas.getContext('2d');
            var chart = new Chart(ctx).#{klass}(data, opts);
            window.Chart[#{element_id.to_json}] = chart;

            var legend = chart.generateLegend();
            if (legend.trim().length > 0) {
              var legendHolder = document.createElement("div");
              legendHolder.innerHTML = legend;
              canvas.parentNode.insertBefore(legendHolder.firstChild, canvas.nextSibling);
            }
          };
          /* W3C standard */
          if (window.addEventListener) {
            window.addEventListener("load", initChart, false);
          }
          /* IE */
          else if (window.attachEvent) {
            window.attachEvent("onload", initChart);
          }
        })();
        END
      end

      content_tag(:figure, canvas, class: css_class) + script
    end

    def data_for(labels, datasets)
      if labels
        "{labels: #{labels.to_json}, datasets: #{datasets.to_json}}"
      else
        datasets.to_json
      end
    end

    def combined_data(datasets)
      datasets.map { |d| d[:data] || d[:value] }.flatten
    end

  end
end
