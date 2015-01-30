require 'support/spec_helper'

module PdfEditor
  describe Merge do 

    before do 
      support_dir = ::File.join(::File.dirname(__FILE__), 'support', 'docs')

      ['merge_1.pdf', 'merge_2.pdf'].each_with_index do |file, i|
        
        ::File.open(::File.join(support_dir, file), 'r') do |f|
          
          ::Tempfile.open(['', '.pdf']) do |tf|
            tf.write f.read 
            instance_variable_set(:"@resource_#{i+1}", PdfEditor::Resource.new(tf))
          end

        end

      end
    end

    describe '#call' do 

      before do 
        @ret = PdfEditor::Merge.call(resources: [@resource_1, @resource_2], merged_name: 'Merged Name')
      end

      it 'returns a resource' do 
        expect(@ret).to be_instance_of PdfEditor::Resource 
      end

      it 'returns a merged document' do
        contents = ''
        @ret.open_file do |f|
          PDF::Reader.new(f).pages.each {|page| contents << page.text}
        end
        expect(contents).to eq 'merge 1merge 2'
        expect(@ret.page_count).to eq 2
      end

      it 'raises an error if no resources are present' do 
        expect{PdfEditor::Merge.call}.to raise_error PdfEditor::Errors::ResourcesEmptyError
      end

      it 'returned resource has merged_name if supplied' do 
        expect(@ret.name).to eq 'Merged Name'
      end

    end

    describe '#format_command' do 

      it 'creates the proper format for merge' do 
        expected_format = [{:pdf => @resource_1.path}, {:pdf => @resource_2.path}]
        service = PdfEditor::Merge.new(resources: [@resource_1, @resource_2])
        expect(service.send(:format_command)).to eq expected_format
      end

    end

  end
end
