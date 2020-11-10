module RN
  module Utils
    def root_path
      Cons::ROOT_PATH
    end

    def valid_name?(name)
      !/\A[-a-z0-9\s]+\Z/i.match(name).nil?
    end

    def default_book
      "#{Cons::ROOT_PATH}/cuaderno_global"
    end
  end
end
