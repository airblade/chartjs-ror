# chartjs-ror

Simplifies using [Chart.js][] in Rails views.


## Current Chart.js version

This gem includes [Chart.js v3.7.1](https://github.com/chartjs/Chart.js/tree/v3.7.1).


## Installation

Add this line to your application's Gemfile:

    gem 'chartjs-ror'

And then execute:

    $ bundle

After that require Chart:

  ```javascript
  //= require Chart.min
  ```

Please note Chart.js [no longer supports IE8 and below](https://github.com/chartjs/Chart.js/issues/2396#issuecomment-215233106).


## Usage

Each chart type has a corresponding helper for your views.  The helper methods take the same arguments as their Javascript counterparts.  The `options` are optional.


```erb
<%= line_chart           data, options %>
<%= bar_chart            data, options %>
<%= horizontal_bar_chart data, options %>
<%= radar_chart          data, options %>
<%= polar_area_chart     data, options %>
<%= pie_chart            data, options %>
<%= doughnut_chart       data, options %>
<%= bubble_chart         data, options %>
<%= scatter_chart        data, options %>
```

If you don't want these helpers – perhaps they clash with other methods in your views – add this initializer to your app:

```ruby
# config/initializers/chartjs.rb
Chartjs.no_conflict!
```

Then you can use these helpers instead:

```erb
<%= chartjs_line_chart           data, options %>
<%= chartjs_bar_chart            data, options %>
<%= chartjs_horizontal_bar_chart data, options %>
<%= chartjs_radar_chart          data, options %>
<%= chartjs_polar_area_chart     data, options %>
<%= chartjs_pie_chart            data, options %>
<%= chartjs_doughnut_chart       data, options %>
<%= chartjs_bubble_chart         data, options %>
<%= chartjs_scatter_chart        data, options %>
```

For example, to render a [line chart][linechart] in Javascript:

```javascript
var data = {
    labels: ["January", "February", "March", "April", "May", "June", "July"],
    datasets: [
        {
            label: "My First dataset",
            backgroundColor: "rgba(220,220,220,0.2)",
            borderColor: "rgba(220,220,220,1)",
            data: [65, 59, 80, 81, 56, 55, 40]
        },
        {
            label: "My Second dataset",
            backgroundColor: "rgba(151,187,205,0.2)",
            borderColor: "rgba(151,187,205,1)",
            data: [28, 48, 40, 19, 86, 27, 90]
        }
    ]
};
var options = { ... };
new Chart(ctx, {
    type: 'Line',
    data: data,
    options: options
});
```

The Ruby equivalent is:

```ruby
data = {
  labels: ["January", "February", "March", "April", "May", "June", "July"],
  datasets: [
    {
        label: "My First dataset",
        backgroundColor: "rgba(220,220,220,0.2)",
        borderColor: "rgba(220,220,220,1)",
        data: [65, 59, 80, 81, 56, 55, 40]
    },
    {
        label: "My Second dataset",
        backgroundColor: "rgba(151,187,205,0.2)",
        borderColor: "rgba(151,187,205,1)",
        data: [28, 48, 40, 19, 86, 27, 90]
    }
  ]
}
options = { ... }
<%= line_chart data, options %>
```

You can also use underscored symbols for keys, instead of the camelcase versions.
They will be converted to their lower camelcase counterparts on output.

```ruby
data = {
  labels: ["January", "February", "March", "April", "May", "June", "July"],
  datasets: [
    {
        label: "My First dataset",
        background_color: "rgba(220,220,220,0.2)",
        border_color: "rgba(220,220,220,1)",
        data: [65, 59, 80, 81, 56, 55, 40]
    },
    {
        label: "My Second dataset",
        background_color: "rgba(151,187,205,0.2)",
        border_color: "rgba(151,187,205,1)",
        data: [28, 48, 40, 19, 86, 27, 90]
    }
  ]
}
options = { ... }
<%= line_chart data, options %>
```

### Options

You can put anything in the `options` hash that Chart.js recognises.  To pass a JavaScript function as an option value, wrap it in quotation marks to make it a string.

You can also use these non-Chart.js settings:

* `:class`          - class of the DOM canvas element - default is `chart`.
* `:id`             - id of the DOM canvas element - default is `chart-n` where `n` is the 0-based index of the chart on the page.
* `:width`          - width of the canvas in px - default is `400`.
* `:height`         - height of the canvas in px - default is `400`.


## Sample output

```html
<canvas id="chart-0" class="chart" width=400 height=400></canvas>
<script type="text/javascript">
  //<![CDATA[
  (function() {
    var initChart = function() {
      var ctx = document.getElementById("chart-0");
      var chart = new Chart(ctx, {
        type: "Line",
        data = { ... };
        options = { ... };
      });
    };

    if (typeof Chart !== "undefined" && Chart !== null) {
      initChart();
    }
    else {
      if (window.addEventListener) {
        window.addEventListener("load", initChart, false);
      }
      else if (window.attachEvent) {
        window.attachEvent("onload", initChart);
      }
    }
  })();
  //]]>
</script>
```

The Javascript is actually written out on a single line but you get the idea.


## Intellectual Property

Copyright Andrew Stewart, AirBlade Software.  Released under the MIT licence.


  [Chart.js]: http://www.chartjs.org/
  [linechart]: http://www.chartjs.org/docs/#line-chart

