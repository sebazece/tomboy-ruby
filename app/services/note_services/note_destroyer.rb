# frozen_string_literal: true

module NoteServices
  class NoteDestroyer < ApplicationService
    def initialize(note)
      @model = note
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
