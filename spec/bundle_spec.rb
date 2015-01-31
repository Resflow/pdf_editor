require 'support/spec_helper'

module PdfEditor
  describe Bundle do 

    before do 
      @resource_1 = get_resource('five_page.pdf', 'Five Page Pdf')
      @resource_2 = get_resource('two_page.pdf', 'Two Page Pdf')
      @service = PdfEditor::Bundle.new(
        resources: [@resource_1, @resource_2], 
        title: 'TOC', 
        with_toc: true, 
        with_title_pages: true
      )
    end

    describe '#create_title_page' do 

      it 'returns a resource' do 
        ret = @service.send(:create_title_page, @resource_1)
        expect(ret).to be_instance_of PdfEditor::Resource
      end
      
    end

    describe '#merge_resource_with_title_page' do 

      it 'creates a single resource with title page and original content' do 
        ret = @service.send(:merge_resource_with_title_page, @resource_1)
        contents = []
        ret.open_file do |f|
          reader = ::PDF::Reader.new(f)
          reader.pages.each {|page| contents << page.text}
        end
        expect(ret.page_count).to eq 6
        expect(contents).to eq ['Five Page Pdf', 'Page 1', 'Page 2', 'Page 3', 'Page 4', 'Page 5']
      end

    end

    # def merge_resource_with_title_page(resource)
    #   title_page_resource = create_title_page(resource)
    #   PdfEditor::Merge.call({
    #     resources: [title_page_resource, resource], 
    #     merged_name: title_page_resource.name
    #   })
    # end

  end
end




# def call
#   create_title_pages
#   create_table_of_contents
#   bundle_documents
# end


# def bundle_documents
#   bundle_resources = ready_for_toc
#   bundle_resources.unshift(table_of_contents) if table_of_contents 
#   PdfEditor::Merge.call({resources: bundle_resources})
# end

# def create_table_of_contents
#   return if ready_for_toc.empty?
#   return unless with_toc

#   self.table_of_contents = PdfEditor::TableOfContents.call({resources: ready_for_toc})
# end

# def create_title_pages
#   ready_for_toc.clear

#   if with_title_pages

#     resources.each do |resource|
#       new_resource = merge_resource_with_title_page(resource)
#       ready_for_toc << new_resource
#     end

#   else
#     self.ready_for_toc = resources.dup
#   end

#   ready_for_toc
# end





