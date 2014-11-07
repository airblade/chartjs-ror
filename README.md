# chartjs-ror

Simplifies using [Chart.js][] in Rails views.

* All of Chart.js's features via one line of Ruby.
* Renders charts on page load rather than DOMContentReady ([reason][browsersupport]).
* Animates unless you have Modernizr and it doesn't detect canvas support ([reason][browsersupport]).  You can manually override this.
* Optional alternative (better?) abscissa scale calculations.
* Utility method for filling in gaps in integer series.


## Installation

Add this line to your application's Gemfile:

    gem 'chartjs-ror'

And then execute:

    $ bundle

In your JavaScript manifest, add:

```javascript
//= require Chart
//= require excanvas
```

You only need [excanvas][ExplorerCanvas] for IE7 and IE8.  Add [Modernizr][] if you need it to your app's assets.


## Usage

Each chart type has a corresponding helper for your views.  The helper methods take the same arguments as their Javascript counterparts.  The `options` are always optional.

### Charts with multiple datasets

```erb
<%= line_chart labels, datasets, options %>
<%= bar_chart labels, datasets, options %>
<%= radar_chart labels, datasets, options %>
```

For example, to render a [line chart][linechart] in Javascript:

```javascript
var data = {
	labels : ["January","February","March","April","May","June","July"],
	datasets : [
		{
			fillColor : "rgba(220,220,220,0.5)",
			strokeColor : "rgba(220,220,220,1)",
			pointColor : "rgba(220,220,220,1)",
			pointStrokeColor : "#fff",
			data : [65,59,90,81,56,55,40]
		},
		{
			fillColor : "rgba(151,187,205,0.5)",
			strokeColor : "rgba(151,187,205,1)",
			pointColor : "rgba(151,187,205,1)",
			pointStrokeColor : "#fff",
			data : [28,48,40,19,96,27,100]
		}
	]
}
var options = {};
new Chart(ctx).Line(data,options);
```

The Ruby equivalent is:

```ruby
@data = {
	labels: ["January","February","March","April","May","June","July"],
	datasets: [
		{
			fillColor: "rgba(220,220,220,0.5)",
			strokeColor: "rgba(220,220,220,1)",
			pointColor: "rgba(220,220,220,1)",
			pointStrokeColor: "#fff",
			data: [65,59,90,81,56,55,40]
		},
		{
			fillColor: "rgba(151,187,205,0.5)",
			strokeColor: "rgba(151,187,205,1)",
			pointColor: "rgba(151,187,205,1)",
			pointStrokeColor: "#fff",
			data: [28,48,40,19,96,27,100]
		}
	]
}
@options = {}
<%= line_chart @data, @options %>
```

### Charts with one dataset

```erb
<%= polar_chart data, options %>
<%= pie_chart data, options %>
<%= doughnut_chart data, options %>
```

For example, to render a [pie chart][piechart] in Javascript:

```javascript
var data = [
	{
		value : 30,
		color: "#D97041"
	},
	{
		value : 90,
		color: "#C7604C"
	},
	{
		value : 24,
		color: "#21323D"
	},
	{
		value : 58,
		color: "#9D9B7F"
	},
	{
		value : 82,
		color: "#7D4F6D"
	},
	{
		value : 8,
		color: "#584A5E"
	}
]
new Chart(ctx).Pie(data,options);
```

And in Ruby:

```ruby
@data = [
	{
		value: 30,
		color: "#D97041"
	},
	{
		value: 90,
		color: "#C7604C"
	},
	{
		value: 24,
		color: "#21323D"
	},
	{
		value: 58,
		color: "#9D9B7F"
	},
	{
		value: 82,
		color: "#7D4F6D"
	},
	{
		value: 8,
		color: "#584A5E"
	}
]
<%= pie_chart @data %>
```

### Options

You can put anything in the `options` hash that Chart.js recognises.  It also supports these non-Chart.js settings:

* `:class`      - class of the enclosing `<figure/>` - default is `chart`.
* `:element_id` - id of the `<canvas/>` - default is `chart-n` where `n` is the 0-based index of the chart on the page.
* `:width`      - width of the canvas in px - default is `400`.
* `:height`     - height of the canvas in px - default is `400`.

### Sample output:

```html
<figure class="chart">
  <canvas id="chart-0" width=400 height=400></canvas>
  <!-- legend rendered here -->
</figure>
<script type="text/javascript">
  (function() {
    var initChart = function() {
      var data = {labels: ["Apples","Bananas","Cherries"], datasets: [{"data":[42,153,...],...}, ...]};
      var opts = {"scaleFontSize":10};
      if (!("animation" in opts)) {
        opts['animation'] = (typeof Modernizr == "undefined") || Modernizr.canvas;
      }
      var canvas = document.getElementById("chart-0");
      var ctx = canvas.getContext('2d');
      var chart = new Chart(ctx).Bar(data, opts);
      window.Chart["chart-0"] = chart;

      var legend = chart.generateLegend();
      if (legend.trim().length > 0) {
        var legendHolder = document.createElement("div");
        legendHolder.innerHTML = legend;
        canvas.parentNode.insertBefore(legendHolder.firstChild, canvas.nextSibling);
      }
    };
    if (window.addEventListener) {
      window.addEventListener('load', initChart, false);
    }
    else if (window.attachEvent) {
      window.attachEvent('onload', initChart);
    }
  })();
</script>
```

The Javascript is actually written out on a single line but you get the idea.


### Templates (tooltips and legends)

If you specify a custom template, e.g. in `legendTemplate` or `tooltipTemplate`, you must escape opening tags in the Javascript-template string, i.e. use `<%%= value %>` instead of `<%= value %>`.

You need to add an escape `%` character for each level of rendering.  For example:

- If your view calls the chart helper directly, use `<%%= value %>`.
- If your view renders a partial which calls the chart helper, use `<%%%= value %>`.


### Legend

A legend will be rendered using `chart.generateLegend()` ([docs][advanced]).

If you don't want a legend, supply `legendTemplate: " "` in the options for your chart.  For some reason an empty string causes an exception inside Chart.js so use a single space.


### Scale calculations

The plugin implements its own abscissa scale calculations which I prefer to Chart.js's (see [Chart.js#132][calculations]).  You can opt-in to these calculations by passing `scaleOverride: true` in the `options` hash, without any of the other scale override keys (`scaleSteps`, `scaleStepWidth`, `scaleStartValue`).


## Inspiration

* [Chart.js][] (obviously)
* [Chartkick][]


## Intellectual Property

Copyright Andrew Stewart, AirBlade Software.  Released under the MIT licence.


  [Chart.js]: http://www.chartjs.org/
  [Chartkick]: https://ankane.github.io/chartkick/
  [browsersupport]: http://www.chartjs.org/docs/#notes-browser-support
  [linechart]: http://www.chartjs.org/docs/#lineChart-exampleUsage
  [piechart]: http://www.chartjs.org/docs/#pieChart-exampleUsage
  [Modernizr]: http://modernizr.com
  [ExplorerCanvas]: https://code.google.com/p/explorercanvas
  [advanced]: http://www.chartjs.org/docs/#advanced-usage-prototype-methods
  [calculations]: https://github.com/nnnick/Chart.js/issues/132
