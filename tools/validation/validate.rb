#!/usr/bin/env ruby
#
# Usage: validate.rb schema.json data.json
#
require 'json'
require 'json-schema'

$verbose = true

# validate some data - raise ValidationError if it doesn't conform
def validate(schema, v)
  JSON::Validator.validate!(schema, v)
  puts "UUID: #{v.first['uuid']}: OK" if $verbose
rescue JSON::Schema::ValidationError => e
  puts "UUID: #{v.first['uuid']}: #{e}"
end

# parse the schema - raise SchemaError if it's invalid
schema = JSON.parse(File.read(ARGV.shift))

ARGV.each do |fn|
  puts "Validating #{fn}" if $verbose
  data = JSON.parse(File.read(fn))
  if data.is_a?(Array)
    data.each do |v|
      validate(schema, [v])
    end
  else
    validate(schema, [data])
  end
end
