# encoding: utf-8
guard 'bundler' do
  watch('^Gemfile')
end

guard 'nanoc' do
  watch('^config.yaml')
  watch('^config/compass.rb')
  watch('^Rules')
  watch('^layouts\/')
  watch('^content\/')
  watch('^lib/helpers.rb')
end

guard 'rspec', :version => 2 do
  watch('^spec/(.*)_spec.rb')
  watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('^app/(.*)\.rb')                              { |m| "spec/app/#{m[1]}_spec.rb" }
  watch('^app/website\.rb')                           { |m| "spec/app" }
  watch('^config/application\.rb')                    { "spec" }
  watch('^spec/spec_helper.rb')                       { "spec" }
end

guard 'livereload', :api_version => '1.5' do
  watch(%r{public/.+\.(css|js|html|jpg)$})
end
