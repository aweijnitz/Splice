#!/usr/bin/env ruby

# Sinple Ruby script to merge two Java properties files.
# Anders Weijnitz


# Validate input
unless ARGV.length == 2
	puts "Oups! I need exactly two files to splice."
  	puts "Usage: ruby splice.rb <file to merge> <file to merge into>\n"
  	puts "Example: ruby splice.rb localizedstrings_sv.properties localizedstrings_en.properties\n"
  exit

end


# Class to read and write Java properties files
# Majority of this code was nicked from a blog post by Devender Gollapally.
# http://www.jroller.com/dgolla/entry/reading_and_writing_java_property
class JavaProps

	attr_accessor :file, :properties

	#Takes a file and loads the properties in that file
	def initialize file

		@file = file
		@properties = {}
		IO.foreach(file) do |line|
			@properties[$1.strip] = $2 if line =~ /([^=]*)=(.*)\/\/(.*)/ || line =~ /([^=]*)=(.*)/
		end
	end


	#Helpfull to string
	def to_s
		output = ""
		@properties.each {|key,value| output += "#{key}=#{value}\n" }
		output
	end


	#Write a property
	def write_property (key,value)
		@properties[key] = value
	end


	#Merge in from other instance
	def merge anotherProp
		anotherProp.properties.each {|key,value| write_property(key, value) }
	end


	#Save the properties back to file
	def save
		file = File.new(@file,"w+")
		@properties.each {|key,value| file.puts "#{key}=#{value}\n" }
	end

end


incomplete = JavaProps.new(ARGV[0])
fallback = JavaProps.new(ARGV[1])
fallback.merge(incomplete)
puts fallback.to_s



