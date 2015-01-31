module PdfEditor
  module Errors

    InvalidPDFError        = Class.new(StandardError)
    InvalidInputError      = Class.new(StandardError)
    PageCountError         = Class.new(StandardError)
    PageRangeError         = Class.new(StandardError)
    TitlePageTitleError    = Class.new(StandardError)
    ResourcesEmptyError    = Class.new(StandardError)
    PageOrderInvalidError  = Class.new(StandardError)
    ArgumentMissingError   = Class.new(StandardError)
    
  end
end