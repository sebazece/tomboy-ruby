module Backend
  class SearchController < BackendController
    def books_and_notes
      @books = []
      @book = Book.find(params[:book_id]) unless params[:book_id].empty?
      @notes = current_user.notes.where("title LIKE ?", "%#{params[:search]}%")

      @notes = @notes.where(book_id: params[:book_id]) unless params[:book_id].empty?
      @books = current_user.books.where("name LIKE ?", "%#{params[:search]}%") if params[:book_id].empty?
      @value = params[:search]
    end
  end
end
