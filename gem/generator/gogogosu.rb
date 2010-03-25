module Generator
  class Gogogosu
    
    def initialize
      @basedir = Dir.pwd
    end
    
    # Generates a directory.
    #
    def dir name
      Dir.mkdir name unless File.file?(name) || File.exist?(name)
      if block_given?
        Dir.chdir name
        yield
        Dir.chdir '..'
      end
    end
    
    # Generates a file. Will be rendered with erb.
    #
    def file name
      
    end
    
  end
end