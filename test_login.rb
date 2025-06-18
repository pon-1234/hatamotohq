#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'json'

# First, get the login page to extract CSRF token
login_page_uri = URI.parse('http://agency.localhost:3000/user/sign_in')
http = Net::HTTP.new(login_page_uri.host, login_page_uri.port)

# Get the login page
request = Net::HTTP::Get.new(login_page_uri.path)
response = http.request(request)

# Extract CSRF token from the page
csrf_token = nil
if response.body =~ /name="authenticity_token" value="([^"]+)"/
  csrf_token = $1
  puts "CSRF Token found: #{csrf_token[0..20]}..."
else
  puts "CSRF Token not found!"
  exit 1
end

# Extract session cookie
cookies = response['set-cookie']
session_cookie = cookies.split(';')[0] if cookies
puts "Session cookie: #{session_cookie}"

# Now attempt login with agency credentials
login_uri = URI.parse('http://agency.localhost:3000/user/sign_in')
http = Net::HTTP.new(login_uri.host, login_uri.port)

request = Net::HTTP::Post.new(login_uri.path)
request['Cookie'] = session_cookie
request['Content-Type'] = 'application/x-www-form-urlencoded'

# Try with agency@example.com
form_data = URI.encode_www_form({
  'authenticity_token' => csrf_token,
  'user[email]' => 'agency@example.com',
  'user[password]' => 'Admin1234@',
  'user[remember_me]' => 'false',
  'commit' => 'ログイン'
})

request.body = form_data
response = http.request(request)

puts "\n=== Testing agency@example.com at /user/sign_in ==="
puts "Response code: #{response.code}"
puts "Response message: #{response.message}"
puts "Location: #{response['location']}" if response['location']

# Check if login was successful
if response.code == '302' || response.code == '303'
  puts "✓ Login appears successful (redirect detected)"
else
  puts "✗ Login failed (no redirect)"
  
  # Check for error messages in response
  if response.body.include?('メールアドレスまたはパスワードが違います')
    puts "Error: Invalid email or password"
  elsif response.body.include?('not_found_in_database')
    puts "Error: User not found in database"
  end
end

# Now try with client@example.com
puts "\n=== Testing client@example.com at /user/sign_in ==="

# Get fresh CSRF token
request = Net::HTTP::Get.new(login_page_uri.path)
response = http.request(request)

if response.body =~ /name="authenticity_token" value="([^"]+)"/
  csrf_token = $1
end
cookies = response['set-cookie']
session_cookie = cookies.split(';')[0] if cookies

# Login with client credentials
request = Net::HTTP::Post.new(login_uri.path)
request['Cookie'] = session_cookie
request['Content-Type'] = 'application/x-www-form-urlencoded'

form_data = URI.encode_www_form({
  'authenticity_token' => csrf_token,
  'user[email]' => 'client@example.com',
  'user[password]' => 'Admin1234@',
  'user[remember_me]' => 'false',
  'commit' => 'ログイン'
})

request.body = form_data
response = http.request(request)

puts "Response code: #{response.code}"
puts "Response message: #{response.message}"
puts "Location: #{response['location']}" if response['location']

if response.code == '302' || response.code == '303'
  puts "✓ Login appears successful (redirect detected)"
else
  puts "✗ Login failed (no redirect)"
end