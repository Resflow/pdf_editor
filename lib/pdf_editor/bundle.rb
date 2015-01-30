require_relative 'title_page'
require_relative 'table_of_contents'
require_relative 'merge'
require_relative 'resource'
require_relative 'mixins/service'

module PdfEditor
  class Bundle
    include PdfEditor::Service

    attr_reader :title, :resources, :with_toc, :with_title_pages

    def post_init
      @resources         = args.fetch(:resources, [])
      @ready_for_toc     = []
      @table_of_contents = nil

      @title             = args.fetch(:title, '')
      @with_toc          = args.fetch(:with_toc, true)
      @with_title_pages  = args.fetch(:with_title_pages, true)
    end 

    def call
      create_title_pages
      create_table_of_contents
      bundle_documents
    end

    private

    attr_accessor :ready_for_toc, :table_of_contents

    def bundle_documents
      bundle_resources = ready_for_toc
      bundle_resources.unshift(table_of_contents) if table_of_contents 
      PdfEditor::Merge.call({resources: bundle_resources})
    end

    def create_table_of_contents
      return if ready_for_toc.empty?
      return unless with_toc

      self.table_of_contents = PdfEditor::TableOfContents.call({resources: ready_for_toc})
    end

    def create_title_pages
      ready_for_toc.clear

      if with_title_pages

        resources.each do |resource|
          new_resource = merge_resource_with_title_page(resource)
          ready_for_toc << new_resource
        end

      else
        self.ready_for_toc = resources.dup
      end

      ready_for_toc
    end


    def merge_resource_with_title_page(resource)
      title_page_resource = create_title_page(resource)
      PdfEditor::Merge.call({
        resources: [title_page_resource, resource], 
        merged_name: title_page_resource.name
      })
    end

    def create_title_page(resource)
      PdfEditor::TitlePage.call({title: resource.name})
    end

  end
end