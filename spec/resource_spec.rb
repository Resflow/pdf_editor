require 'support/spec_helper'

module PdfEditor 
  describe Resource do 

    before :each do 
      tempfile = ::Tempfile.new(['', '.pdf'])
      @resource = Resource.new(tempfile, 'open file test')
    end

    describe '#read' do 

      it 'calls open file' do 
        @resource.stub(:open_file) { @resource.file }
        expect(@resource).to receive(:open_file)
        @resource.read
      end

      it 'rewinds before reading' do 
        contents = 'Move the buffer position'
        @resource << contents
        expect(@resource.read).to eq contents
      end

    end

    describe '#open_file' do 

      context 'when file is closed' do 

        it 'opens file' do 
          @resource.open_file do |f|
            expect(f).to_not be_closed
          end
        end

      end

      context 'when file is open' do 

        it 'yields open file' do 
          @resource.close 
          @resource.open_file do |f|
            expect(f).to_not be_closed 
          end
        end

      end

      it 'closes file after yield' do 
        @resource.open_file do |f|
          f.write "yippee!"
        end
        expect(@resource).to be_closed
      end

    end

    describe '#write' do 

      it 'writes the contents to the file' do 
        contents = 'ABCDEF'
        @resource.open
        @resource.write(contents)
        @resource.rewind 
        expect(@resource.file.read).to eq contents
      end

    end

    describe '#page_count' do 

      context 'when file is a pdf' do 

        it 'returns the number of pages of the file' do 
          file_path = File.join(File.dirname(__FILE__), 'support', 'docs', 'two_page.pdf')

          File.open(file_path, 'r') do |file|
            resource = Resource.new(file, 'pdf test')
            expect(resource.page_count).to eq 2
          end
        end

      end

      context 'when file is not a pdf' do 

        it 'raises an error' do 
          file_path = File.join(File.dirname(__FILE__), 'support', 'docs', 'not_a_pdf.txt')

          File.open(file_path, 'r') do |file|
            resource = Resource.new(file, 'pdf test')
            expect{resource.page_count}.to raise_error PdfEditor::Errors::InvalidPDFError
          end
        end

      end

    end

    describe '#method_missing' do 

      it 'delegates messages to file when it responds to them' do 
        [:delete, :open, :path, :size, :read, :close, :close!].each do |io_interface|
          expect(@resource).to respond_to io_interface
        end
      end

      it 'does not delegate when file does not respond to a message' do 
        messages = [:goofy, :mickey, :bigbird]
        @resource.file.stub(:goofy)   { 'goofy' }
        @resource.file.stub(:mickey)  { 'mickey' }
        @resource.file.stub(:bigbird) { 'bigbird' }
        messages.each do |bunk_message|
          @resource.send(bunk_message)
        end
        messages.each do |bunk_message|
          expect(@resource.file).to_not receive(bunk_message)
        end
      end

    end

    after :each do 
      @resource.close!
    end

  end
end