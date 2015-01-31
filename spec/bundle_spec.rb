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

    describe '#call' do 

      before do 
        @service.stub(:create_title_pages) { nil }
        @service.stub(:create_table_of_contents) { nil }
        @service.stub(:bundle_documents) { nil }
      end

      it 'calls #create_title_pages' do 
        expect(@service).to receive(:create_title_pages)
        @service.call
      end

      it 'calls #create_table_of_contents' do 
        expect(@service).to receive(:create_table_of_contents)
        @service.call
      end

      it 'calls #bundle_documents' do 
        expect(@service).to receive(:bundle_documents)
        @service.call 
      end

    end

    describe '#create_title_pages' do 

      context 'when with_title_pages' do 

        it 'creates title pages' do 
          service = PdfEditor::Bundle.new(
            resources: [@resource_1, @resource_2], 
            title: 'TOC', 
            with_toc: true, 
            with_title_pages: true
          )
          service.send(:create_title_pages)
          ready_for_toc = service.send(:ready_for_toc)
          page_count = ready_for_toc.inject(0) {|sum, resource| sum + resource.page_count}
          expect(page_count).to eq 9
        end

      end

      context 'when not with_title_pages' do 

        it 'does not create title pages' do 
          service = PdfEditor::Bundle.new(
            resources: [@resource_1, @resource_2], 
            title: 'TOC', 
            with_toc: true, 
            with_title_pages: false
          )
          service.send(:create_title_pages)
          ready_for_toc = service.send(:ready_for_toc)
          page_count = ready_for_toc.inject(0) {|sum, resource| sum + resource.page_count}
          expect(page_count).to eq 7
        end

      end

    end

    describe '#create_table_of_contents' do 

      it 'does nothing if ready_for_toc is empty' do
        service = PdfEditor::Bundle.new(
          resources: [], 
          title: 'TOC', 
          with_toc: true, 
          with_title_pages: false
        )
        service.send(:create_table_of_contents)
        expect(service.send(:table_of_contents)).to be_nil
      end

      it 'does nothing if not with_toc' do
        service = PdfEditor::Bundle.new(
          resources: [@resource_1, @resource_2], 
          title: 'TOC', 
          with_toc: false, 
          with_title_pages: false
        )
        service.send(:create_table_of_contents)
        expect(service.send(:table_of_contents)).to be_nil
      end

      it 'sets table_of_contents to generated table_of_contents' do 
        service = PdfEditor::Bundle.new(
          resources: [@resource_1, @resource_2], 
          title: 'TOC', 
          with_toc: true, 
          with_title_pages: true
        )
        service.stub(:ready_for_toc) {[@resource_1, @resource_2]}
        service.send(:create_table_of_contents)
        expect(service.send(:table_of_contents)).to be_instance_of PdfEditor::Resource
      end

    end

    describe '#bundle_documents' do 

      it 'merges the table_of_contents with the contents' do 
        service = PdfEditor::Bundle.new(
          resources: [@resource_1, @resource_2], 
          title: 'TOC', 
          with_toc: true, 
          with_title_pages: true
        )
        ret = service.call
        expect(ret.page_count).to eq 10
      end

    end

  end
end
