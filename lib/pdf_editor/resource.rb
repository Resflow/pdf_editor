require 'pdf/reader'
require_relative 'mixins/errors'

module PdfEditor
  class Resource
    include PdfEditor::Errors

    #
    # Object that contains a tempfile and other pertinent
    # info about that file, such as it's name and page count. 
    # All methods are delegated to file that aren't found in
    # Resource.
    #

    attr_reader :file, :name

    def initialize(file, name=nil)
      @file = file
      @name = name 
    end

    def read(length=nil)
      open_file do |f|
        f.rewind
        f.read(length)
      end
    end

    def open_file
      begin 
        file.open if file.closed? 
        yield file
      ensure
        file.close 
      end
    end

    def write(contents)
      file.write(contents)
    end

    def page_count
      open_file do |f|
        ::PDF::Reader.new(f).page_count
      end
    rescue PDF::Reader::MalformedPDFError => e 
      raise Errors::InvalidPDFError, e.message
    end

    def respond_to_missing?(method_sym, include_private=false)
      file.respond_to?(method_sym, include_private) || super
    end

    def method_missing(method, *args, &b)
      file.send(method, *args, &b)
    end

  end
end