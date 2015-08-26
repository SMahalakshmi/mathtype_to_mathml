require "mathtype_to_mathml/version"
require "nokogiri"
require "mathtype"
require_relative "mathtype_to_mathml/mover"
require_relative "mathtype_to_mathml/char_replacer"
require "pry"

module MathTypeToMathML 
  class Converter
    def initialize(mathtype)
     
      @xslt = Nokogiri::XSLT(File.open(File.join(File.dirname(__FILE__), "transform.xsl")))

      @mathtype = Mathtype::Converter.new(mathtype).xml.doc

      puts @mathtype
      
      # Addresses lack of scaning mode in our translator. See "Mover" for more.
      mover = Mover.new(@mathtype)
      mover.move

      # Character ranges are tricky in XSLT 1.0, so we deal with them in Ruby
      char_replacer = CharReplacer.new(@mathtype)
      char_replacer.replace
    end

    def convert
      @xslt.transform(@mathtype).to_s
    end
  end
end
