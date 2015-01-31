require 'support/spec_helper'

module PdfEditor
  describe TableOfContents do 

    describe '#call' do 

      it 'raises an error when there are no resources' do 
        expect{PdfEditor::TableOfContents.call}.to raise_error PdfEditor::Errors::ResourcesEmptyError
      end

    end

  end
end
