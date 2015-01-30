require 'active_pdftk'

module PdfEditor
  module PdfRunner

    def pdf_runner
      @pdf_runner ||= ::ActivePdftk::Wrapper.new
    end

  end
end