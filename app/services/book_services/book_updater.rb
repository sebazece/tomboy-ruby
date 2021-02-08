# frozen_string_literal: true

module BookServices
  class BookUpdater < ApplicationService
    def initialize(params, book)
      @params = params
      @model = book
      super()
    end

    def call
      if @model.update(@params)
        success
      else
        error
      end
    end
  end
end