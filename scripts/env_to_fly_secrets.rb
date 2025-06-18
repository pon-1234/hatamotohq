#!/usr/bin/env ruby
# frozen_string_literal: true

# Convert .env file to Fly.io secrets commands
# Usage: ./env_to_fly_secrets.rb .env.development hatamotohq-dev

require 'shellwords'

if ARGV.length != 2
  puts "Usage: #{$0} <env_file> <fly_app_name>"
  exit 1
end

env_file = ARGV[0]
app_name = ARGV[1]

unless File.exist?(env_file)
  puts "Error: Environment file '#{env_file}' not found"
  exit 1
end

puts "# Fly.io secrets for #{app_name}"
puts "# Generated from #{env_file}"
puts "# Run these commands to set secrets:"
puts

# Read and parse .env file
File.foreach(env_file) do |line|
  # Skip comments and empty lines
  next if line.strip.empty? || line.strip.start_with?('#')
  
  # Parse KEY=VALUE format
  if line =~ /^([^=]+)=(.*)$/
    key = $1.strip
    value = $2.strip
    
    # Remove quotes if present
    value = value[1..-2] if (value.start_with?('"') && value.end_with?('"')) || 
                           (value.start_with?("'") && value.end_with?("'"))
    
    # Skip certain keys that Fly.io sets automatically
    next if %w[DATABASE_URL PORT].include?(key)
    
    # Escape the value for shell
    escaped_value = Shellwords.escape(value)
    
    puts "fly secrets set #{key}=#{escaped_value} --app #{app_name}"
  end
end

puts
puts "# Or import all at once:"
puts "fly secrets import < #{env_file} --app #{app_name}"