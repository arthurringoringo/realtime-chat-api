
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


module RequestIntegrationTest
  extend ActiveSupport::Concern

  included do
    include ActionDispatch::Integration::Runner
    include ActionDispatch::IntegrationTest::Behavior
    include HelpersForRequest
  end
end
