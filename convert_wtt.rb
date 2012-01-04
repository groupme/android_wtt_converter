#!/usr/bin/env ruby

require 'rubygems'
require 'xmlsimple'





def convertFile(filename, savePath = nil)
  puts "Converting #{File.basename(filename)}"


  file = File.new(filename, 'r')
  contents = file.read.force_encoding("UTF-8")
  file.close

  doc = XmlSimple.xml_in(contents)

  output = ""

  doc['content']['item'].each do |s|
    key = s['key']
    val = s['content'].gsub("\n", "\\n")
    output += "<string name=\"#{key}\">#{val}</string>\n"
  end

  m = File.basename(filename).split("_")
  outputFilename = "strings_#{m[0]}_#{m[1]}.xml"
  if (savePath != nil)
    outputFilename = File.join(savePath, outputFilename)
  end
  outputFile = File.new(outputFilename, 'w');
  outputFile.write(output)
  outputFile.close();

  puts "Succesfully created #{outputFilename}"
end


filename = ARGV[0]

if (filename != nil)

  if (File.file? filename)
    convertFile(filename)
  elsif (File.directory? filename)
    saveDir = File.join(filename, "output")
    if (!File.exists?(saveDir))
      Dir.mkdir(saveDir)
    end
    Dir.foreach(filename) do |file|
      if ( file != nil && File.file?(file.to_s) && /xml$/.match(file.to_s) )
        convertFile(file.to_s, saveDir.to_s)
      end
    end
  end
  
else
  puts "You need to specify a file or directory containing WTT translation XML files"
end