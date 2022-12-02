# vi: ft=ruby

# good helper methods for interactive sessions
require_relative "ruby/good_irb_helper_methods"
Object.prepend(GoodIRBHelperMethods)
