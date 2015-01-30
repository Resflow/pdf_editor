require 'support/spec_helper'

module PdfEditor 
  describe TitlePage do 

    it 'raises an error when no title is passed' do 
      expect{TitlePage.call}.to raise_error PdfEditor::Errors::TitlePageTitleError
    end

    it 'does not raise an error when an empty title is passed' do 
      expect{TitlePage.call(title: '')}.to_not raise_error
    end

    describe '#call' do 

      before :each do 
        @ret = TitlePage.call(title: 'this is a title')
      end

      it 'returns a resource' do 
        expect(@ret).to be_instance_of PdfEditor::Resource
      end

      it 'resource has the contents of the title' do 
        contents = ''
        @ret.open_file do |f|
          contents = PDF::Reader.new(f).pages[0].text
        end
        expect(contents).to eq 'this is a title'
      end

    end

  end
end
