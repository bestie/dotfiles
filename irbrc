# vi: ft=ruby

# require useful gems
gems = [
  "pry",
  "active_support",
]
gems.each do |gem_name|
  begin
    require gem_name
  rescue Object => e
    puts "Couldn't require #{gem_name}"
  end
end

# require useful stdlibs
libs = [
  "base64",
  "benchmark",
  "digest",
  "fileutils",
  "json",
  "logger",
  "net/http",
  "ostruct",
  "securerandom",
  "shellwords",
  "stringio",
  "time",
  "uri",
]
libs.each do |lib_name|
  begin
    require lib_name
  rescue Object => e
    puts "Couldn't require #{lib_name}"
  end
end

# good helper methods for interactive sessions
require_relative "ruby/good_irb_helper_methods"
Object.prepend(GoodIRBHelperMethods)

require_relative "ruby/reline_history_fzf_patch"
puts "reline!"
