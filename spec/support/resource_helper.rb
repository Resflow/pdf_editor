require 'pdf_editor/resource'

module PdfEditor
  module ResourceHelper

    def get_resource(doc_name, name=nil)
      resource = nil
      file_path = ::File.join(::File.dirname(__FILE__), 'docs', doc_name)
      ::File.open(file_path, 'r') do |f|
        ::Tempfile.open(['', '.pdf']) do |tf|
          tf.write f.read
          resource = PdfEditor::Resource.new(tf, name)
        end
      end
      return resource
    end

  end
end