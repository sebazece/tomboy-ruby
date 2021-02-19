module Backend
  class NotesController < BackendController
    before_action :set_note, only: %I[show edit update destroy]
    def new
      @note = Note.new
      @selected_book_id = params[:book_id]
    end

    def create
      result = NoteServices::NoteCreator.call(note_params, current_user)
      if result.success?
        return redirect_to backend_notes_from_book_path(note_params[:book_id]) if note_params[:book_id].present?

        redirect_to backend_books_path
      else
        @note = result.object
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      result = NoteServices::NoteUpdater.call(note_params, @note)
      if result.success?
        return redirect_to backend_notes_from_book_path(@note.book_id) unless @note.book.nil?

        redirect_to backend_books_path
      else
        @note = result.object
        render :new
      end
    end

    def destroy
      result = NoteServices::NoteDestroyer.call(@note)
      if result.success?
        return redirect_to backend_notes_from_book_path(@note.book_id) if @note.book.present?

        redirect_to root_path
      else
        @note = result.object
        render :new
      end
    end

    private

    def set_note
      @note = Note.by_user(current_user.id).find(params[:id])
    end

    def note_params
      params.require(:note).permit(:title, :body, :book_id)
    end
  end
end
