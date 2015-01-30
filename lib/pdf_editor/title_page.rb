require_relative 'resource'
require_relative 'mixins/service'
require_relative 'mixins/prawn_dsl'

module PdfEditor
  class TitlePage
    include PdfEditor::Service
    include PdfEditor::PrawnDSL
    include PdfEditor::Errors

    attr_reader :title 

    def post_init
      @title = args[:title]
    end

    def call
      unless title
        raise Errors::TitlePageTitleError, 'Title page requires a title to operate'
      end
      PdfEditor::Resource.new(
        create_tempfile {create_pdf}, 
        title
      )
    end

    private

    def create_pdf
      update_pdf do 
        move_down 30
        text title, size: 40, align: :center
      end
      to_pdf
    end

  end
end