# frozen_string_literal: true

module BookServices
  class BookCreator < ApplicationService
    attr_reader :book

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
      super()
    end

    def call
      @model = Book.new(@params)
      @model.user_id = @current_user.id
      @model.save ? success : error
    end
  end
end
