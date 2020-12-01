module RN
  module Utils
    PERMITTED_CHARS = /\A[-_a-z0-9\s]+\Z/i.freeze

    def root_path
      path = Cons::ROOT_PATH
      Dir.mkdir(path) unless File.exist?(path)
      path
    end

    def valid_name?(name)
      !PERMITTED_CHARS.match(name).nil?
    end

    def default_book_path
      path = "#{root_path}/.cuaderno_global"
      Dir.mkdir(path) unless File.exist?(path)
      path
    end

    def export_file(pdf_file_path, converter)
      File.open(pdf_file_path, 'w') { |f| f.puts converter.convert }
    end
  end
end
