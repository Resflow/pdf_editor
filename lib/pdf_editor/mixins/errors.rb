module PdfEditor
  module Errors

    InvalidPDFError        = Class.new(StandardError)
    InvalidInputError      = Class.new(StandardError)
    PageCountCommandError  = Class.new(StandardError)
    PageRangeError         = Class.new(StandardError)
    TitlePageTitleError    = Class.new(StandardError)
    ResourcesEmptyError    = Class.new(StandardError)
    PageOrderInvalidError  = Class.new(StandardError)
    
  end
end