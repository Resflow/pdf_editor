require_relative 'resource'
require_relative 'mixins/service'
require_relative 'mixins/pdf_runner'
require_relative 'mixins/errors'

module PdfEditor
  class RotatePage
    include PdfEditor::Service
    include PdfEditor::PdfRunner
    include PdfEditor::Errors

    ROTATIONS = {
      left:   'left',
      right:  'right',
      flip:   'down'
    }

    attr_reader :resource, :page, :rotate

    def post_init
      @resource   = args.fetch(:resource, nil)
      @page       = args.fetch(:page, nil)
      @rotate     = ROTATIONS[args.fetch(:rotate, '')]
    end

    def call
      return if resource.nil? || page.nil? || rotate.nil?
      PdfEditor::Resource.new(
        create_tempfile {run_command}
      )
    end

    private

    def run_command
      read_from_io do 
        pdf_runner.cat(format_command)
      end
    end

    def get_page_count
      pages_count = resource.page_count
      if page_count == 0
        raise PageCountCommandError, "Error returning the number of pages for #{resource.path}" 
      end
      if page_count < 1 || page > page_count
        raise PageRangeError, "Page #{page} does not exist. There are #{page_count} pages "
      end
      page_count
    end

    def format_command
      page_count = get_page_count
      page_nums  = Array(1..page_count)

      before_page = page_nums[0, page_nums.index(page)]

      first_page_after = page_nums.index(page+1) || page_nums.length
      after_page = page_nums[first_page_after, page_nums.length]

      result = []
      result << {:pdf => resource.path, :start => before_page.first, :end => before_page.last} unless before_page.empty?
      result << {:pdf => resource.path, :start => page, :end => page, :orientation => rotate}
      result << {:pdf => resource.path, :start => after_page.first, :end => after_page.last} unless after_page.empty?
      result
    end

  end
end