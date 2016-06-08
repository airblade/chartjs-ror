module Chartjs
  module ChartHelpers

    CHART_TYPES = %w[ bar bubble doughnut line polar_area radar scatter ]

    module Explicit
      CHART_TYPES.each do |type|
        define_method "chartjs_#{type}_chart" do |data, options = {}|    # def chartjs_polar_area_chart(data, options = {})
          chart type, data, options                                      #   chart 'polar_area', data, options
        end                                                              # end
      end
      include Chartjs::ChartHelpers
    end

    module Implicit
      CHART_TYPES.each do |type|
        define_method "#{type}_chart" do |data, options = {}|            # def polar_area_chart(data, options = {})
          chart type, data, options                                      #   chart 'polar_area', data, options
        end                                                              # end
      end
      include Chartjs::ChartHelpers
    end

    private

    def chart(type, data, options)
      @chart_id ||= -1
      element_id = options.delete(:id)     || "chart-#{@chart_id += 1}"
      css_class  = options.delete(:class)  || 'chart'
      width      = options.delete(:width)  || '400'
      height     = options.delete(:height) || '400'

      canvas = content_tag :canvas, '', id: element_id, class: css_class, width: width, height: height

      script = javascript_tag do
        # Ensure option string values which are actually JavaScript functions
        # are treated as functions.
        <<-END.squish.html_safe
        (function() {
          var initChart = function() {
            var ctx = document.getElementById(#{element_id.to_json});
            var chart = new Chart(ctx, {
              type:    "#{camel_case type}",
              data:    #{data.to_json},
              options: #{options.to_json.gsub /"(function.*?})"/, '\1'}
            });
          };

          if (typeof Chart !== "undefined" && Chart !== null) {
            initChart();
          }
          else {
            /* W3C standard */
            if (window.addEventListener) {
              window.addEventListener("load", initChart, false);
            }
            /* IE */
            else if (window.attachEvent) {
              window.attachEvent("onload", initChart);
            }
          }
        })();
        END
      end

      canvas + script
    end

    # polar_area -> polarArea
    def camel_case(string)
      string.sub(/_([a-z])/) { $1.upcase }
    end

  end
end
