# chartjs-ror

Simplifies using [Chart.js][] in Rails views.

* All of Chart.js's features via one line of Ruby.
* Legends for your charts.
* Renders charts on page load rather than DOMContentReady ([reason][browsersupport]).
* Animates unless you have Modernizr and it doesn't detect canvas support ([reason][browsersupport]).  You can manually override this.

NOTE: this is Rails 3.0 only at the moment, so pre-asset pipeline.  I plan to upgrade soon.


## Installation

Add this line to your application's Gemfile:

    gem 'chartjs-ror'

And then execute:

    $ bundle

Add [Chart.js][] (and [Modernizr][] and [ExplorerCanvas][] if you need them) to your assets.

Ensure your browsers will display `<figure/>` and `<figcaption/>` correctly.


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

* `:css_class` - class of the enclosing `<figure/>` - default is `chart`.
* `:element_id` - id of the `<canvas/>` - default is `chart-n` where `n` is the 0-based index of the chart on the page.
* `:width` - width of the canvas in px - default is `400`.
* `:height` - height of the canvas in px - default is `400`.
* `:legend` - an array of names for the datasets.

### Sample output:

```html
<figure class="chart">
  <canvas id="chart-0" width=400 height=400></canvas>
  <!-- if :legend option is given -->
  <figcaption>
    <ol>
      <li class="chart-0 dataset-0"><span></span>Apples</li>
      <li class="chart-0 dataset-1"><span></span>Bananas</li>
      <li class="chart-0 dataset-2"><span></span>Cherries</li>
    </ol>
  </figcaption>
</figure>
<script type="text/javascript">
  var initChart = function() {
    var data = {labels: ["Apples","Bananas","Cherries"], datasets: [{"data":[42,153,...],...}, ...]};
    var opts = {"scaleFontSize":10};
    if (!('animation' in opts)) {
      opts['animation'] = (typeof Modernizr == 'undefined') || Modernizr.canvas;
    }
    var ctx = document.getElementById("chart-0").getContext('2d');
    new Chart(ctx).Bar(data, opts);
  };
  if (window.addEventListener) { // W3C standard
    window.addEventListener('load', initChart, false);
  }
  else if (window.attachEvent) { // IE
    window.attachEvent('onload', initChart);
  }
</script>
```

### Legend

Each item in the legend array is given two classes:

* `dataset-m` where `m` is the 0-based index of the item.
* The id value of the canvas.

This lets you style legends in general but override the styles for specific charts.


## Inspiration

* [Chart.js][] (obviously)
* [Chartkick][]


## Intellectual Property

Copyright Andrew Stewart, AirBlade Software.  Released under the MIT licence.


  [Chart.js]: http://www.chartjs.org/
  [Chartkick]: http://ankane.github.io/chartkick/
  [browsersupport]: http://www.chartjs.org/docs/#generalIssues-browserSupport
  [linechart]: http://www.chartjs.org/docs/#lineChart-exampleUsage
  [piechart]: http://www.chartjs.org/docs/#pieChart-exampleUsage
  [Modernizr]: http://modernizr.com
  [ExplorerCanvas]: https://code.google.com/p/explorercanvas
