require 'test_helper'

require 'chartjs/chart_helpers'

class ChartHelpersTest < Minitest::Test

  class Foo
    include Chartjs::ChartHelpers

    def to_js(element)
      to_javascript_string element
    end
  end

  def setup
    @subject = Foo.new
  end

  def test_to_javascript_string
    assert_equal '"foo"', @subject.to_js('foo')

    assert_equal '["a",42]', @subject.to_js(['a', 42])

    assert_equal '{"a":42}', @subject.to_js({'a' => 42})

    assert_equal '{"a":function(x) { blah; }}', @subject.to_js({'a' => 'function(x) { blah; }'})

    expected = \
'{"a":function(x) {
  if (x) {
    foo();
  }
  else {
    bar();
  }
}
}'

    assert_equal expected, @subject.to_js({'a' => <<END})
function(x) {
  if (x) {
    foo();
  }
  else {
    bar();
  }
}
END
  end

end
