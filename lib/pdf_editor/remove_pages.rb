require_relative 'shuffle'

module PdfEditor
  class RemovePages < Shuffle

    #
    # Page order has a unique set of members and
    # is sorted. This allows pdftk to not burst
    # the document into single pages where possible.
    #

    def post_init
      super
      @page_order = @page_order.uniq.sort
    end

    private

    def format_command
      consecutive_pages = find_consecutives
      consecutive_pages.map do |sub_arr|
        {
          :pdf => resource.path,
          :start => sub_arr.first,
          :end => sub_arr.last
        }
      end
    end

    def find_consecutives
      enum = page_order.to_enum
      result, consecutives = [], []
      
      loop do 
        consecutives << enum.next 
        unless enum.peek == consecutives.last.succ
          result << consecutives
          consecutives = []
        end
      end
      
      result << consecutives unless consecutives.empty?
      result
    end

  end
end