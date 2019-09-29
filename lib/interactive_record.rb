require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

    def initialize(attributes={})
        attributes.each do |key, value|
            self.send("#{key}=", value) 
        end 
    end
    
    def self.table_name
        self.name.downcase.pluralize
    end

    def self.column_names
        DB[:conn].results_as_hash = true
        sql = "pragma table_info('#{table_name}')"
        table_info = DB[:conn].execute(sql)
        column_names = []
        table_info.each do |row|
          column_names << row["name"]
        end
        column_names
    end

    def table_name_for_insert
        self.class.to_s.downcase.pluralize
    end

    def col_names_for_insert
        self.class.column_names.drop(1).join(", ")
    end

    def values_for_insert
        insert_values = []
        self.class.column_names.each do |column_name|
            insert_values << "'#{send(column_name)}'" unless !send(column_name)
        end
        insert_values.join(", ")
    end

    def save
        sql = "INSERT INTO #{self.table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
        DB[:conn].execute(sql)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
    end

    def self.find_by_name(name_to_find)
        sql = "SELECT * FROM #{self.table_name} WHERE name = ?"
        DB[:conn].execute(sql, name_to_find)
    end

    def self.find_by(attribute)
        value_to_find = attribute.values.first
        sql = "SELECT * FROM #{self.table_name} WHERE #{attribute.keys.first} = ?"
        DB[:conn].execute(sql, value_to_find)
    end

    


end