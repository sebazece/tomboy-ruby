# frozen_string_literal: true

class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  private

  def success
    OpenStruct.new({ success?: true })
  end

  def error
    OpenStruct.new({ success?: false,
                     errors: @model.errors,
                     object: @model })
  end
end
