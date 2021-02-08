# frozen_string_literal: true

module NoteServices
  class NoteUpdater < ApplicationService
    def initialize(params, note)
      @params = params
      @model = note
      super()
    end

    def call
      @model.update(custom_private) ? success : error
    end

    private

    def custom_private
      @params[:book_id] = book_id
      @params
    end

    def book_id
      return if @params[:book_id] == 'global'

      @params[:book_id]
    end
  end
end
