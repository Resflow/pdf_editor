require 'bundler/setup'
Bundler.setup

require 'pdf_editor'
require 'support/resource_helper'
require 'pry'

RSpec.configure do |config|
  
  config.include PdfEditor::ResourceHelper

end