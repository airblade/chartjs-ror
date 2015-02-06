module Chartjs
  module ChartHelpers

    %w[ Line Bar Radar PolarArea Pie Doughnut ].each do |type|
      camel_type = type.gsub(/(\w)([A-Z])/, '\1_\2').downcase
      define_method "#{camel_type}_chart" do |data, options = {}|    # def polar_area_chart(data, options = {})
        chart type, data, options                                    #   chart 'PolarArea', data, options
      end                                                            # end
    end

    private

    def chart(klass, data, options)
      @chart_id ||= -1
      element_id = options.delete(:id)     || "chart-#{@chart_id += 1}"
      css_class  = options.delete(:class)  || 'chart'
      width      = options.delete(:width)  || '400'
      height     = options.delete(:height) || '400'

      canvas = content_tag(:canvas, id: element_id, width: width, height: height) do
      end

      # Alternative scale calculations.
      if options[:scaleOverride] && !options.has_key?(:scaleSteps)
        options.merge! ordinate_scale(combined_data(data))
      end

      generate_legend = options.delete :generateLegend
      legend = <<-END
        var legend = chart.generateLegend();
        var legendHolder = document.createElement("div");
        legendHolder.innerHTML = legend;
        canvas.parentNode.insertBefore(legendHolder.firstChild, canvas.nextSibling);
      END

      script = javascript_tag do
        <<-END.squish.html_safe
        $(function() {
        
          var initChart = function() {
            var data = #{data.to_json};
            var opts = #{options.to_json};
            if (!("animation" in opts)) {
              opts["animation"] = (typeof Modernizr == "undefined") || Modernizr.canvas;
            }
            
            chart && chart.destroy();
            
            var canvas = document.getElementById(#{element_id.to_json});
            var ctx = canvas.getContext('2d');
            var chart = new Chart(ctx).#{klass}(data, opts);
            window.Chart[#{element_id.to_json}] = chart;

            #{legend if generate_legend}
          };
          /* W3C standard */
          if (window.addEventListener) {
          /*  window.addEventListener("load", initChart, false);
            document.addEventListener("page:load", initChart, false);*/
            initChart();
          }
          /* IE */
          else if (window.attachEvent) {
            window.attachEvent("onload", initChart);
            document.attachEvent("page:load", initChart);
          }
        })();
        END
      end

      content_tag(:figure, canvas, class: css_class) + script
    end

    def combined_data(data)
      if data.is_a? Array
        data.map { |datum| datum[:value] }
      else
        data[:datasets].flat_map { |dataset| dataset[:data] }
      end
    end

  end
end
