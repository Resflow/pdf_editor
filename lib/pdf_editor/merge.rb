require_relative 'resource'
require_relative 'mixins/service'
require_relative 'mixins/pdf_runner'
require_relative 'mixins/errors'

module PdfEditor
  class Merge
    include PdfEditor::Service
    include PdfEditor::PdfRunner
    include PdfEditor::Errors

    attr_reader :resources, :merged_name

    def post_init
      @resources   = args.fetch(:resources, [])
      @merged_name = args.fetch(:merged_name, nil)
    end

    def call
      if resources.empty?
        raise Errors::ResourcesEmptyError, 
              'There must be at least one resource to merge'
      end
      PdfEditor::Resource.new(
        create_tempfile {run_command},
        merged_name
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
      resources.map do |resource|
        {:pdf => resource.path}
      end
    end

  end
end
