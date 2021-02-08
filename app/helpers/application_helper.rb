module ApplicationHelper
  def book_options
    options = [['-', 'global']]
    options << [@note.book.name, @note.book.id] if @note.book.present?
    Book.by_user(current_user.id).each do |book|
      options << [book.name, book.id]
    end
    options
  end

  def show_errors(object, field_name)
    if object.errors.any?
      unless object.errors.messages[field_name].blank?
        object.errors.messages[field_name].join(', ')
      end
    end
  end
end
