module Backend
  class BooksController < BackendController
    before_action :set_book, only: %I[edit update destroy]

    def index
      @books = Book.by_user(current_user.id)
      @global_notes = current_user.notes.where(book_id: nil)
    end

    def new
      @book = Book.new
    end

    def create
      result = BookServices::BookCreator.call(book_params, current_user)
      if result.success?
        redirect_to backend_books_path
      else
        @book = result.object
        render :new
      end
    end

    def show
      @book = if params[:id] == 'nil'
                OpenStruct.new(
                  name: '-',
                  notes: OpenStruct.new(count: global_book_notes_count)
                )
              else
                Book.by_user(current_user.id).find(params[:id])
              end
    end

    def edit; end

    def update
      result = BookServices::BookUpdater.call(book_params, @book)
      if result.success?
        redirect_to backend_notes_from_book_path(@book.id)
      else
        @book = result.object
        render :new
      end
    end

    def destroy
      result = BookServices::BookDestroyer.call(@book)
      if result.success?
        redirect_to backend_books_path
      else
        @book = result.object
        render :new
      end
    end

    def notes
      @book = Book.find(params[:id])
    end

    private

    def book_params
      params.require(:book).permit(:name)
    end

    def global_book_notes_count
      current_user.notes.where(book_id: nil).count
    end

    def set_book
      @book = Book.by_user(current_user.id).find(params[:id])
    end
  end
end
