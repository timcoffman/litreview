require 'active_record/connection_adapters/postgresql_adapter'

ActiveRecord::ConnectionAdapters::PostgreSQLColumn.class_eval do

    # Escapes binary strings for bytea input to the database.
    def self.string_to_binary(value)
      if PGconn.respond_to?(:escape_bytea)
        self.class.module_eval do
          define_method(:string_to_binary) do |value|
            PGconn.escape_bytea(value) if value
          end
        end
      else
        self.class.module_eval do
          define_method(:string_to_binary) do |value|
            if value
              result = ''
              value.each_byte { |c| result << sprintf('\\\\\\\\%03o', c) } ### patched to add additional level of escaping
              result
            end
          end
        end
      end
      self.class.string_to_binary(value)
    end

end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do

  # Quotes PostgreSQL-specific data types for SQL input.
  def quote(value, column = nil) #:nodoc:
    if value.kind_of?(String) && column && column.type == :binary
      "#{quoted_string_prefix}'#{column.class.string_to_binary(value).gsub('\\','\\\\\\\\')}'"
    elsif value.kind_of?(String) && column && column.sql_type =~ /^xml$/
      "xml '#{quote_string(value)}'"
    elsif value.kind_of?(Numeric) && column && column.sql_type =~ /^money$/
      # Not truly string input, so doesn't require (or allow) escape string syntax.
      "'#{value.to_s}'"
    elsif value.kind_of?(String) && column && column.sql_type =~ /^bit/
      case value
        when /^[01]*$/
          "B'#{value}'" # Bit-string notation
        when /^[0-9A-F]*$/i
          "X'#{value}'" # Hexadecimal notation
      end
    else
      super
    end
  end

end

