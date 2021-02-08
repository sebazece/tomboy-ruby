# frozen_string_literal: true

module BookServices
  class BookDestroyer < ApplicationService
    def initialize(book)
      @model = book
      super()
    end

    def call
      if @model.destroy
        success
      else
        error
      end
    end
  end
end
