#!/usr/bin/env ruby

require 'medium_sdk'
require 'dotenv'

Dotenv.load

MEDIUM_TOKEN = ENV['MEDIUM_TOKEN']
client = MediumSdk.new(integration_token: MEDIUM_TOKEN)

blog_post_file_path = ARGV[0]
content = File.read(blog_post_file_path)
content_by_line = content.split("\n")

# Extract title from file
header = Hash[/---(.*)---/im.match(content)[1].strip.split("\n").map { |line| line.split(": ").map(&:strip) }]
title = header["title"].gsub("\"", "")

# Extract tags from file
tags = header["categories"].split(" ")

puts "Do you want to post file '#{blog_post_file_path}'? N/y"
puts ""
puts "Title:"
puts ""
puts "\t#{title}"
puts ""
puts "Tags:"
puts "\t#{tags.join(', ')}"
puts ""

unless  STDIN.getc == "y"
  puts "Bye! :-)"
  exit 0
end

puts "Publish post ..."
data = client.post({
  title: title,
  contentFormat: "markdown",
  content: content,
  tags: tags,
  publishStatus: "draft"
})

puts "Check your post at '#{data['url']}'"
