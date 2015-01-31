require 'support/spec_helper'

module PdfEditor
  describe RotatePage do 

    before do 
      @resource = get_resource('two_page.pdf')
    end

    describe '#call' do 

      it 'rotates the page to the left' do 
        # rotation of document is calculated clockwise
        before = %x(pdftk #{@resource.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        ret = PdfEditor::RotatePage.call(resource: @resource, page: 1, rotate: :left)
        after = %x(pdftk #{ret.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        expect(before[0].to_i).to eq 0
        expect(after[0].to_i).to eq 270
      end

      it 'rotates the page to the right' do 
        # rotation of document is calculated clockwise
        before = %x(pdftk #{@resource.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        ret = PdfEditor::RotatePage.call(resource: @resource, page: 1, rotate: :right)
        after = %x(pdftk #{ret.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        expect(before[0].to_i).to eq 0
        expect(after[0].to_i).to eq 90
      end

      it 'rotates the page upside down' do 
        # rotation of document is calculated clockwise
        before = %x(pdftk #{@resource.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        ret = PdfEditor::RotatePage.call(resource: @resource, page: 1, rotate: :flip)
        after = %x(pdftk #{ret.file.path} dump_data | grep PageMediaRotation | sed 's/[^0-9]*//').split("\n")
        expect(before[0].to_i).to eq 0
        expect(after[0].to_i).to eq 180
      end

      it 'raises an error if resource is not present' do 
        expect{PdfEditor::RotatePage.call(page: 1, rotate: :left)}.to raise_error PdfEditor::Errors::ArgumentMissingError
      end

      it 'raises an error if page is not present' do 
        expect{PdfEditor::RotatePage.call(resource: @resource, rotate: :left)}.to raise_error PdfEditor::Errors::ArgumentMissingError
      end

      it 'raises an error if rotate is not present' do 
        expect{PdfEditor::RotatePage.call(resource: @resource, page: 1)}.to raise_error PdfEditor::Errors::ArgumentMissingError
      end

    end

    describe '#get_page_count' do 

      it 'raises an error if page count is 0' do 
        @resource.stub(:page_count) { 0 }
        service = PdfEditor::RotatePage.new(resource: @resource, page: 1, rotate: :left)
        expect{service.send(:get_page_count)}.to raise_error PdfEditor::Errors::PageRangeError
      end

      it 'raises an error if page is out of range' do 
        @resource.stub(:page_count) { 2 }
        service = PdfEditor::RotatePage.new(resource: @resource, page: 3, rotate: :left)
        expect{service.send(:get_page_count)}.to raise_error PdfEditor::Errors::PageRangeError
      end

    end

    describe '#format_command' do 

      it 'returns the proper format' do 
        resource = get_resource('five_page.pdf')
        expected_format = [
          {:pdf => resource.path, :start => 1, :end => 3},
          {:pdf => resource.path, :start => 4, :end => 4, :orientation => 'left'},
          {:pdf => resource.path, :start => 5, :end => 5}
        ]
        service = PdfEditor::RotatePage.new(resource: resource, page: 4, rotate: :left)
        expect(service.send(:format_command)).to eq expected_format
      end

    end

  end
end
