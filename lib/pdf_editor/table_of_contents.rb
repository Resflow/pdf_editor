require_relative 'resource'
require_relative 'mixins/service'
require_relative 'mixins/prawn_dsl'

module PdfEditor
  class TableOfContents
    include PdfEditor::Service
    include PdfEditor::PrawnDSL

    attr_reader :resources

    def post_init
      @resources = args.fetch(:resources, [])
    end

    def call
      return if resources.empty?
      PdfEditor::Resource.new(
        create_tempfile {create_pdf}
      )
    end

    def create_pdf
      update_pdf do 
        header
        body
      end
      to_pdf
    end

    def header
      move_down 20
      text 'applicant_name', size: 40, align: :center
      move_down 50
    end

    def body
      begin_page_count = 1 # TOC normally doesn't count itself as a page

      resources.inject(begin_page_count) do |page_location, resource|
        text "#{resource.name}........................#{page_location}"
        move_down 10 

        page_location + resource.page_count 
      end
    end

  end
end