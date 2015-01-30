require 'prawn'

module PdfEditor
  module PrawnDSL

    def document
      @document ||= Prawn::Document.new
    end

    def update_pdf(&b)
      instance_eval(&b)
    end

    def to_pdf
      document.render
    end

    def save_to_file(file_name)
      document.render_file(file_name)
    end

    def respond_to_missing?(method_sym, include_private=false)
      document.respond_to_missing?(method_sym, include_private) || super
    end

    def method_missing(method, *args, &b)
      document.send(method, *args, &b)
    end

  end
end