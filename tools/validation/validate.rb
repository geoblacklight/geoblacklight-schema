#!/usr/bin/env ruby

require 'json'
require 'json-schema'

$verbose = false

# validate some data - raise ValidationError if it doesn't conform
def validate(schema, v)
  JSON::Validator.validate!(schema, v)
  puts "UUID: #{v['uuid']}: OK" if $verbose
rescue JSON::Schema::ValidationError => e
  puts "UUID: #{v['uuid']}: #{e}"
end

# parse the schema - raise SchemaError if it's invalid
schema = JSON.parse(File.read('../../geoblacklight-schema.json'))

ARGV.each do |fn|
  puts "Validating #{fn}" if $verbose
  data = JSON.parse(File.read(fn))
  if data.is_a?(Array)
    data.each do |v|
      validate(schema, v)
    end
  else
    validate(schema, data)
  end
end
