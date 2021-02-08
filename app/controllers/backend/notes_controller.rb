module Backend
  class NotesController < BackendController
    before_action :set_note, only: %I[show edit update destroy]

    def index
      @notes = Note.by_user(current_user.id)
    end

    def new
      @note = Note.new
    end

    def create
      result = NoteServices::NoteCreator.call(note_params, current_user)
      if result.success?
        redirect_to backend_notes_path
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
        redirect_to backend_notes_path
      else
        @note = result.object
        render :new
      end
    end

    def destroy
      result = NoteServices::NoteDestroyer.call(@note)
      if result.success?
        redirect_to backend_notes_path
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
