#!/usr/bin/env ruby

require 'json'
require 'json_schema'

# validate some data - raise ValidationError if it doesn't conform
def validate(schema, v)
  schema.validate!(v)
rescue JsonSchema::ValidationError, RuntimeError => e
  puts "UUID: #{v['uuid']}: #{e}"
end

# parse the schema - raise SchemaError if it's invalid
schema_data = JSON.parse(File.read('../../geoblacklight-schema.json'))
schema = JsonSchema.parse!(schema_data)

ARGV.each do |fn|
  puts "Validating #{fn}"
  data = JSON.parse(File.read(fn))
  if data.is_a?(Array)
    data.each do |v|
      validate(schema, v)
    end
  else
    validate(schema, data)
  end
end
