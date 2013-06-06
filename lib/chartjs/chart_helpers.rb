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
      element_id = options.delete(:id) || "chart-#{@chart_id += 1}"
      css_class  = options.delete(:class)  || 'chart'
      width  = options.delete(:width)  || '400'
      height = options.delete(:height) || '400'

      canvas = content_tag(:canvas, id: element_id, width: width, height: height) do
      end

      # <figcaption>
      #   <ol>
      #     <li class="chart-0 dataset-0"><span/>Apples</li>
      #     <li class="chart-0 dataset-1"><span/>Bananas</li>
      #     <li class="chart-0 dataset-2"><span/>Cherries</li>
      #   </ol>
      # </figcaption>
      legend = if options[:legend]
                 content_tag :figcaption do
                   content_tag :ol do
                     options.delete(:legend).each_with_index do |name, index|
                       concat content_tag(:li, (content_tag(:span) + name), class: "#{element_id} dataset-#{index}")
                     end
                   end
                 end
               else
                 ''
               end

      script = javascript_tag do
        <<-END.html_safe
        var initChart = function() {
          var data = #{data_for labels, datasets};
          var opts = #{options.to_json};
          if (!('animation' in opts)) {
            opts['animation'] = (typeof Modernizr != 'undefined') || Modernizr.canvas;
          }
          var ctx = document.getElementById(#{element_id.to_json}).getContext('2d');
          new Chart(ctx).#{klass}(data, opts);
        };
        if (window.addEventListener) { // W3C standard
          window.addEventListener('load', initChart, false);
        }
        else if (window.attachEvent) { // IE
          window.attachEvent('onload', initChart);
        }
        END
      end

      content_tag(:figure, (canvas + legend), class: css_class) + script
    end

    def data_for(labels, datasets)
      if labels
        "{labels: #{labels.to_json}, datasets: #{datasets.to_json}}"
      else
        datasets.to_json
      end
    end

  end
end
