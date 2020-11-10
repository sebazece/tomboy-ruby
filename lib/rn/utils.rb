module RN
  module Utils
    PERMITTED_CHARS = /\A[-a-z0-9\s]+\Z/i.freeze

    def root_path
      path = Cons::ROOT_PATH
      Dir.mkdir(path) unless File.exist?(path)
      path
    end

    def valid_name?(name)
      !PERMITTED_CHARS.match(name).nil?
    end

    def default_book
      path = "#{root_path}/cuaderno_global"
      Dir.mkdir(path) unless File.exist?(path)
      path
    end
  end
end
