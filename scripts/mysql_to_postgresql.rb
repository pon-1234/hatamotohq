#!/usr/bin/env ruby
# frozen_string_literal: true

# MySQL to PostgreSQL Schema Converter
# This script converts MySQL schema and data to PostgreSQL format

require 'optparse'

class MySQLToPostgreSQLConverter
  MYSQL_TO_PG_TYPES = {
    'tinyint(1)' => 'boolean',
    'tinyint' => 'smallint',
    'smallint' => 'smallint',
    'mediumint' => 'integer',
    'int' => 'integer',
    'bigint' => 'bigint',
    'float' => 'real',
    'double' => 'double precision',
    'decimal' => 'decimal',
    'datetime' => 'timestamp',
    'timestamp' => 'timestamp',
    'date' => 'date',
    'time' => 'time',
    'year' => 'integer',
    'char' => 'char',
    'varchar' => 'varchar',
    'text' => 'text',
    'tinytext' => 'text',
    'mediumtext' => 'text',
    'longtext' => 'text',
    'blob' => 'bytea',
    'tinyblob' => 'bytea',
    'mediumblob' => 'bytea',
    'longblob' => 'bytea',
    'binary' => 'bytea',
    'varbinary' => 'bytea',
    'enum' => 'varchar',
    'set' => 'varchar',
    'json' => 'json',
    'jsonb' => 'jsonb'
  }.freeze

  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
    @in_create_table = false
    @current_table = nil
    @sequences = []
  end

  def convert
    File.open(@output_file, 'w') do |output|
      output.puts "-- Converted from MySQL to PostgreSQL"
      output.puts "-- Generated at: #{Time.now}"
      output.puts
      output.puts "SET client_encoding = 'UTF8';"
      output.puts "SET standard_conforming_strings = on;"
      output.puts

      File.foreach(@input_file) do |line|
        converted_line = process_line(line)
        output.puts converted_line if converted_line
      end

      # Add sequences for auto-increment columns
      @sequences.each do |seq|
        output.puts seq
      end
    end

    puts "Conversion completed: #{@output_file}"
  end

  private

  def process_line(line)
    # Skip MySQL-specific comments and commands
    return nil if line =~ /^--\s*MySQL/
    return nil if line =~ /^\/\*!\d+/
    return nil if line =~ /^LOCK TABLES/
    return nil if line =~ /^UNLOCK TABLES/
    return nil if line =~ /^SET\s+.*=\s*@@/

    # Handle CREATE TABLE
    if line =~ /^CREATE TABLE\s+`?(\w+)`?\s*\(/i
      @in_create_table = true
      @current_table = $1
      return "CREATE TABLE #{@current_table} ("
    end

    # Handle end of CREATE TABLE
    if @in_create_table && line =~ /^\)\s*ENGINE=/i
      @in_create_table = false
      return ");"
    end

    # Process column definitions inside CREATE TABLE
    if @in_create_table
      return process_column_definition(line)
    end

    # Handle INSERT statements
    if line =~ /^INSERT INTO\s+`?(\w+)`?\s*\(/i
      return line.gsub(/`/, '"').gsub(/\\'/,"''").gsub(/\\"/,'"').gsub(/\\\\/,'\\')
    end

    # Handle DROP TABLE
    if line =~ /^DROP TABLE/i
      return line.gsub(/`/, '"').gsub(/IF EXISTS/, 'IF EXISTS').sub(/;/, ' CASCADE;')
    end

    # Handle indexes
    if line =~ /^CREATE\s+(UNIQUE\s+)?INDEX/i
      return line.gsub(/`/, '"')
    end

    # Default: return the line with backticks replaced
    line.gsub(/`/, '"')
  end

  def process_column_definition(line)
    # Skip certain MySQL-specific lines
    return nil if line =~ /^\s*PRIMARY KEY/i
    return nil if line =~ /^\s*KEY/i
    return nil if line =~ /^\s*INDEX/i
    return nil if line =~ /^\s*UNIQUE KEY/i
    return nil if line =~ /^\s*CONSTRAINT/i

    # Process column definition
    if line =~ /^\s*`?(\w+)`?\s+(\w+)(\([^)]+\))?\s*(.*?)(,)?$/i
      column_name = $1
      mysql_type = $2.downcase
      type_params = $3
      modifiers = $4
      comma = $5

      # Convert type
      pg_type = convert_type(mysql_type, type_params)

      # Handle AUTO_INCREMENT
      if modifiers =~ /AUTO_INCREMENT/i
        pg_type = 'SERIAL' if mysql_type =~ /int/i
        pg_type = 'BIGSERIAL' if mysql_type == 'bigint'
        modifiers = modifiers.gsub(/AUTO_INCREMENT/i, '')
      end

      # Handle NOT NULL
      if modifiers =~ /NOT NULL/i
        pg_type += ' NOT NULL'
        modifiers = modifiers.gsub(/NOT NULL/i, '')
      end

      # Handle DEFAULT
      if modifiers =~ /DEFAULT\s+(.+?)(\s|,|$)/i
        default_value = $1
        # Convert MySQL defaults to PostgreSQL
        default_value = 'false' if default_value == '0' && pg_type =~ /boolean/i
        default_value = 'true' if default_value == '1' && pg_type =~ /boolean/i
        default_value = 'CURRENT_TIMESTAMP' if default_value =~ /CURRENT_TIMESTAMP/i
        
        pg_type += " DEFAULT #{default_value}"
      end

      # Handle PRIMARY KEY
      if modifiers =~ /PRIMARY KEY/i
        pg_type += ' PRIMARY KEY'
      end

      return "  #{column_name} #{pg_type}#{comma}"
    end

    line
  end

  def convert_type(mysql_type, params)
    # Check for exact match first
    if MYSQL_TO_PG_TYPES.key?(mysql_type)
      pg_type = MYSQL_TO_PG_TYPES[mysql_type]
    else
      # Check for type with parameters
      base_type = mysql_type
      if MYSQL_TO_PG_TYPES.key?(base_type)
        pg_type = MYSQL_TO_PG_TYPES[base_type]
      else
        # Default fallback
        pg_type = 'text'
        puts "Warning: Unknown MySQL type '#{mysql_type}', using 'text'"
      end
    end

    # Add parameters if applicable
    if params && pg_type =~ /^(varchar|char|decimal|numeric)$/
      pg_type += params
    end

    pg_type
  end
end

# Main script
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: mysql_to_postgresql.rb [options]"

  opts.on("-i", "--input FILE", "Input MySQL dump file") do |i|
    options[:input] = i
  end

  opts.on("-o", "--output FILE", "Output PostgreSQL file") do |o|
    options[:output] = o
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    exit
  end
end.parse!

if options[:input].nil? || options[:output].nil?
  puts "Error: Both input and output files must be specified"
  puts "Use -h for help"
  exit 1
end

converter = MySQLToPostgreSQLConverter.new(options[:input], options[:output])
converter.convert