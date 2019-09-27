require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord
  attr_accessor :id, :name, :grade
  # self.column_names.each do |col_name|
  #   p col_name.to_sym
  #   attr_accessor col_name.to_sym
  # end

end
