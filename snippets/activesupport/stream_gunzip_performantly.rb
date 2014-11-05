# Probably some older rails version?
# Snippet by tbuehlmann:freenode
#
# config/initializers/gzip_json_request.rb
#
ActionDispatch::ParamsParser::DEFAULT_PARSERS[Mime::Type.lookup('gzip/json')] = lambda do |raw_body|
  body = ActiveSupport::Gzip.decompress(raw_body)
  ActiveSupport::JSON.decode(body).with_indifferent_access
end
