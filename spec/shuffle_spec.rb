require 'support/spec_helper'

module PdfEditor 
  describe Shuffle do 

    before do 
      ::File.open(::File.join(::File.dirname(__FILE__), 'support', 'docs', 'five_page.pdf'), 'r') do |f|
        ::Tempfile.open(['', '.pdf']) do |tf|
          tf.write f.read
          @resource = PdfEditor::Resource.new(tf)
        end
      end
    end

    describe '#call' do 

      it 'raises an error if resource is nil' do 
        expect{PdfEditor::Shuffle.call(page_order: [1,2])}.to raise_error PdfEditor::Errors::ResourcesEmptyError
      end

      it 'raises an error if page_order is empty' do 
        expect{PdfEditor::Shuffle.call(resource: @resource)}.to raise_error PdfEditor::Errors::PageOrderInvalidError
      end

      it 'returns a resource' do 
        ret = PdfEditor::Shuffle.call(resource: @resource, page_order: [5, 4, 3, 1, 2])
        expect(ret).to be_instance_of PdfEditor::Resource
      end

      it 'returns a document in the correct order' do 
        ret = PdfEditor::Shuffle.call(resource: @resource, page_order: [5, 4, 3, 1, 2])
        contents = []
        ret.open_file do |f|
          PDF::Reader.new(f).pages.each {|page| contents << page.text}
        end
        contents = contents.join(' ')
        expect(contents).to eq 'Page 5 Page 4 Page 3 Page 1 Page 2'
      end

      it 'can work with duplicates' do 
        ret = PdfEditor::Shuffle.call(resource: @resource, page_order: [5, 4, 3, 1, 2, 5])
        contents = []
        ret.open_file do |f|
          PDF::Reader.new(f).pages.each {|page| contents << page.text}
        end
        contents = contents.join(' ')
        expect(contents).to eq 'Page 5 Page 4 Page 3 Page 1 Page 2 Page 5'
      end

    end

    describe '#format_command' do 

      it 'returns the correct format' do 
        expected_format = [
          {:pdf => @resource.path, :start => 5, :end => 5},
          {:pdf => @resource.path, :start => 4, :end => 4},
          {:pdf => @resource.path, :start => 3, :end => 3},
          {:pdf => @resource.path, :start => 1, :end => 1},
          {:pdf => @resource.path, :start => 2, :end => 2}
        ]
        service = PdfEditor::Shuffle.new(resource: @resource, page_order: [5, 4, 3, 1, 2])
        expect(service.send(:format_command)).to eq expected_format
      end

    end

  end
end
