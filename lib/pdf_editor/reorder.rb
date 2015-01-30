require_relative 'shuffle'

module PdfEditor
  class Reorder < Shuffle

    # 
    # Page order requires a unique set of members
    # and is not sorted.
    #

    def post_init
      super
      @page_order = @page_order.uniq
    end

  end


end