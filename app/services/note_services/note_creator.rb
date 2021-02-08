# frozen_string_literal: true

module NoteServices
  class NoteCreator < ApplicationService
    attr_reader :note

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
      super()
    end

    def call
      @model = Note.new(@params)
      @model.book_id = book_id
      @model.user_id = @current_user.id
      @model.save ? success : error
    end

    private

    def book_id
      return if @params[:book_id] == 'global'

      @model.book_id
    end
  end
end
