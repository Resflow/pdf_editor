require 'support/spec_helper'

module PdfEditor
  describe RemovePages do 

    before do 
      file_path = ::File.join(::File.dirname(__FILE__), 'support', 'docs', 'five_page.pdf')
      ::File.open(file_path, 'r') do |f|
        ::Tempfile.open(['', '.pdf']) do |tf|
          tf.write f.read
          @resource = PdfEditor::Resource.new(tf)
        end
      end
    end

    describe '#call' do 

      it 'returns a document with the pages removed' do 
        ret = PdfEditor::RemovePages.call(resource: @resource, page_order: [2,1,5])
        contents = []
        ret.open_file do |f|
          PDF::Reader.new(f).pages.each {|page| contents << page.text}
        end
        contents = contents.join(' ')
        expect(contents).to eq 'Page 1 Page 2 Page 5'
      end

    end

    describe '#find_consecutives' do 

      it 'returns consecutives in the proper format' do 
        service = PdfEditor::RemovePages.new(resource: @resource, page_order: [1,5,6,2,10,11,3])
        expected_format = [[1,2,3], [5,6], [10,11]]
        expect(service.send(:find_consecutives)).to eq expected_format
      end

    end

    describe '#format_command' do 

      it 'returns the proper format' do 
        expected_format = [
          {:pdf => @resource.path, :start => 1, :end => 3},
          {:pdf => @resource.path, :start => 5, :end => 6},
          {:pdf => @resource.path, :start => 10, :end => 11}
        ]
        service = PdfEditor::RemovePages.new(resource: @resource, page_order: [1,5,6,2,10,11,3])
        expect(service.send(:format_command)).to eq expected_format
      end

    end

  end
end
