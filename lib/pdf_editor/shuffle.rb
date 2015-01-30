require_relative 'resource'
require_relative 'mixins/service'
require_relative 'mixins/pdf_runner'
require_relative 'mixins/errors'

module PdfEditor
  class Shuffle
    include PdfEditor::Service
    include PdfEditor::PdfRunner
    include PdfEditor::Errors

    #
    # Page order does not require unique members and
    # is not sorted. This is the base class for other
    # shuffle operations.
    #

    attr_reader :resource, :page_order

    def post_init
      @resource   = args[:resource]
      @page_order = args.fetch(:page_order, [])
    end

    def call
      if resource.nil?
        raise Errors::ResourcesEmptyError, 'Must have a resource to shuffle'
      end
      if page_order.empty?
        raise Errors::PageOrderInvalidError, 'Page order was invalid'
      end
      PdfEditor::Resource.new(
        create_tempfile {run_command}
      )
    end

    private 

    def run_command
      read_from_io do 
        pdf_runner.cat(format_command)
      end
    rescue ::ActivePdftk::CommandError => e 
      raise InvalidInputError, e.message
    end

    def format_command
      page_order.map do |page_num|
        {
          :pdf => resource.path, 
          :start => page_num, 
          :end => page_num
        }
      end
    end

  end
end
