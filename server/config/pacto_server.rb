require 'pacto'

Pacto.configure do |c|
  c.strict_matchers = options[:strict]
end

config[:stubbed] = options[:backend_host].nil?
config[:backend] = options[:backend_host] ||= 'http://example.com'
Pacto.load_all(options[:directory], config[:backend])
if config[:stubbed]
  Pacto.use(:default)
else
  WebMock.allow_net_connect!
end

if options[:generate]
  Pacto.generate!
  logger.info 'Pacto generation mode enabled'
end
if options[:validate]
  Pacto.validate!
  unless config[:stubbed]
    Pacto.use(:default)
    WebMock.reset!
  end
  logger.info 'Pacto validation mode enabled'
end
