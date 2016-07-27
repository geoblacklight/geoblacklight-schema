desc 'Generate schema documentation'
task :doc do
  sh 'prmd doc -o geoblacklight-schema.md geoblacklight-schema.json'
end

desc 'Validate example data against schema'
task :validate do
  sh 'ruby tools/validation/validate.rb geoblacklight-schema.json examples/selected.json'
end

desc 'Verify schema'
task :verify do
  sh 'prmd verify geoblacklight-schema.json'
end

task default: %w(doc validate)
