require 'goliath'

class PactoServer < Goliath::API
  use Goliath::Rack::Params

  def response (env)
    path = env[Goliath::Request::REQUEST_PATH]
    headers = env['client-headers']
    begin
      uri = "#{config[:backend]}#{path}"
      env.logger.info 'forwarding to: ' + uri
      safe_headers = headers.reject {|k,v| ['host'].include? k.downcase }
      env.logger.debug "filtered headers: #{safe_headers}"
      resp = HTTParty.get(uri, headers: safe_headers, query: env.params)
      code = resp.code
      safe_response_headers = resp.headers.reject {|k,v| ['transfer-encoding'].include? k.downcase}
      [resp.code, safe_response_headers, resp.body]
    rescue => e
      [500, {}, e.message]
    end
  end

  def options_parser(opts, options)
    options[:strict] = false
    options[:directory] = "contracts"
    opts.on('-g', '--generate', 'Generate Contracts from requests') { |val| options[:generate] = true }
    opts.on('-V', '--validate', 'Validate requests/responses against Contracts') { |val| options[:validate] = true }
    opts.on('-m', '--match-strict', 'Enforce strict request matching rules') { |val| options[:strict] = true }
    opts.on('-x', '--contracts_dir DIR', 'Directory that contains the contracts to be registered') { |val| options[:directory] = val }
    opts.on('-H', '--host HOST', 'Host of the real service, for generating or validating live requests') { |val| options[:backend_host] = val }
  end

  def on_headers(env, headers)
    env.logger.info 'proxying new request: ' + headers.inspect
    env['client-headers'] = headers
  end

end
