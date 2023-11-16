# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec::Matchers.define :be_json_type do |expected|
  match do |actual|
    case expected
    when Array then expect(actual).to be_array_type(expected, ["json"])
    when Hash then expect(actual).to be_hash_type(expected, ["json"])
    end
  rescue RSpec::Expectations::ExpectationNotMetError => e
    @message = e.message
    @message += "\n#{JSON.pretty_generate(actual)}"
    false
  end

  failure_message do
    @message
  end
end


RSpec::Matchers.define :be_array_type do |expected, path|
  match do |actual|
    expect(actual).to be_a(Array)
    expected.empty? && (return expect(actual).to eq expected)
    actual.empty? && (return expect(actual).to eq expected)

    expected = actual.length.times.map { expected[0] } if expected.length == 1

    expected.each_with_index.all? do |spec_el, i|
      @spec_el = spec_el
      @value_el = value_el = actual[i]
      @el_path = el_path = path + ["[#{i}]"]
      case spec_el
      when Array then expect(value_el).to be_array_type(spec_el, el_path)
      when Hash then expect(value_el).to be_hash_type(spec_el, el_path)
      when Module then value_el.is_a?(spec_el)
      when RSpec::Matchers::Composable then expect(value_el).to spec_el
      when Float then expect(value_el).to be_within(0.00000001).of(spec_el)
      else value_el == spec_el
      end
    end
  rescue RSpec::Expectations::ExpectationNotMetError => e
    @message = e.message
    false
  end

  failure_message do
    @value_el = "\"#{@value_el}\"" if @value_el.is_a?(String)
    @value_el = "nil" if @value_el.nil?
    @message || "#{@el_path.join("")} was #{@value_el}, expected to be #{@spec_el}"
  end
end

RSpec::Matchers.define :be_hash_type do |expected, path|
  match do |actual|
    expect(actual).to be_a(Hash)
    expected.empty? && (return expect(actual).to eq expected)
    actual.empty? && (return expect(actual).to eq expected)

    expected.all? do |key, spec_el|
      @spec_el = spec_el
      @value_el = value_el = actual.fetch(key) { actual[key.to_s] }
      @el_path = el_path = path + ["[:#{key}]"]
      case spec_el
      when Array then expect(value_el).to be_array_type(spec_el, el_path)
      when Hash then expect(value_el).to be_hash_type(spec_el, el_path)
      when Module then value_el.is_a?(spec_el)
      when RSpec::Matchers::Composable then expect(value_el).to spec_el
      when Float then expect(value_el).to be_within(0.00000001).of(spec_el)
      else value_el == spec_el
      end
    end
  rescue RSpec::Expectations::ExpectationNotMetError => e
    @message = e.message
    false
  end

  failure_message do |_actual|
    @value_el = "\"#{@value_el}\"" if @value_el.is_a?(String)
    @value_el = "nil" if @value_el.nil?
    @message || "#{@el_path.join("")} was #{@value_el}, expected to be #{@spec_el}"
  end
end


module HelpersForRequest

  def get_json(url, body = {}, headers = {})
    get url, params: body, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "Rspec-Test",
      )
  end

  def post_json(url, body = {}, headers = {})
    post url, params: body.to_json, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "Rspec-Test",
      )
  end

  def put_json(url, body = {}, headers = {})
    put url, params: body.to_json, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "Rspec-Test",
      )
  end

  def patch_json(url, body = {}, headers = {})
    patch url, params: body.to_json, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "Rspec-Test",
      )
  end

  def delete_json(url, body = {}, headers = {})
    delete url, params: body.to_json, headers: headers.reverse_merge(
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "Rspec-Test",
      )
  end

  def expect_response(status, json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end
    expect(response_body).to be_json_type(json) if json
  end

  def expect_error_response(status = nil, message = nil, details: nil)
    status ||= Integer
    message ||= String
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] || status
    error_format = { error: message }
    error_format[:error][:details] = details if details

    begin
      if status == Integer
        error_message = "expected: 4xx, got: #{response.status}"
        expect(response.client_error?).to eq(true), error_message
      else
        expect(response).to have_http_status(code)
      end
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end

    expect(response_body).to be_json_type(error_format)

    error_message = response_body[:error]
    if error_message.is_a?(String)
      expect(error_message).not_to match(/translation missing:/), error_message
    end
  end

  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

end

RSpec.configure do |config|
  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.

  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "spec/examples.txt"

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
=end

  config.include HelpersForRequest, type: :request
end
