module RN
  module Commands
    class Exports
      require 'rn/models/export'
      class Note < Dry::CLI::Command
        desc 'Export a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                   # Export a note called "todo" from the global book',
          'todo --book "My book"  # Export a note called "todo" from "My book" book',
          'todo --book newBook    # Export a note called "todo" from newBook book'
        ]

        def call(title:, **options)
          book = options[:book]
          export = Models::Export.new
          export.note(title, book)
        end
      end

      class Book < Dry::CLI::Command
        desc 'Export all notes in a book'

        argument :book, required: false, desc: 'Title of the book'
        option :global, type: :boolean, default: false, desc: 'Export all notes from the global book'

        example [
          '--global   # Export all notes from the global book',
          'todo       # Export all notes from todo book'
        ]

        def call(book: nil, **options)
          global = options[:global]
          export = Models::Export.new
          export.book(book, global)
        end
      end

      class All < Dry::CLI::Command
        desc 'Expot all notes from all books'

        example [
          '     # Export all notes from all books'
        ]

        def call(**)
          export = Models::Export.new
          export.all
        end
      end
    end
  end
end