require 'tempfile'

module PdfEditor
  module Service

    InterfaceNotImplementedError = Class.new(StandardError)
    MustPassBlockToAsTempfile    = Class.new(StandardError)

    def self.included(klass)
      klass.extend ClassMethods
    end

    def initialize(args={})
      @args = args
      post_init
    end

    # overwrite to use the args hash
    def post_init
    end

    def call
      raise InterfaceNotImplementedError, 'Service Interface requires call to be defined'
    end

    private def args
      @args
    end

    private def create_tempfile 
      tempfile = ::Tempfile.open(['', '.pdf'])
      begin 
        file_contents = yield tempfile.path
        tempfile.write(file_contents)
      ensure
        tempfile.close
      end
      tempfile
    end

    private def read_from_io
      io = yield
      io.rewind
      return io.read
    end

    module ClassMethods

      def call(args={})
        service = new(args)
        service.call
      end

    end

  end
end