module RN
  module Commands
    module Notes
      ERRORS = {
        invalid_name: 'El nombre de la nota es inválido',
        book_not_found: 'Cuaderno no encontrado',
        note_not_found: 'Nota no encontrada',
        book_note_not_found: 'El cuaderno o nota no existe',
        alredy_exists: 'Ya existe una nota con ese título'
      }.freeze

      class Create < Dry::CLI::Command
        include RN::Utils

        desc 'Create a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Creates a note titled "todo" in the global book',
          '"New note" --book "My book" # Creates a note titled "New note" in the book "My book"',
          'thoughts --book Memoires    # Creates a note titled "thoughts" in the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          return warn ERRORS[:invalid_name] unless valid_name?(title)

          path = book.nil? ? default_book : "#{root_path}/#{book}"

          return warn ERRORS[:book_not_found] unless File.exist?(path)

          return warn ERRORS[:alredy_exists] if File.exist?(path + "/#{title}.rn")

          TTY::Editor.open(path + "/#{title}.rn")
          puts '!Nota creada exitosamente!'
        end
      end

      class Delete < Dry::CLI::Command
        include RN::Utils

        desc 'Delete a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Deletes a note titled "todo" from the global book',
          '"New note" --book "My book" # Deletes a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Deletes a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]

          path = book.nil? ? "#{default_book}/#{title}.rn" : "#{root_path}/#{book}/#{title}.rn"

          return warn ERRORS[:book_note_not_found] unless File.exist?(path)

          File.delete(path)

          puts '¡Nota eliminada exitosamente!'
        end
      end

      class Edit < Dry::CLI::Command
        include RN::Utils

        desc 'Edit the content a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Edits a note titled "todo" from the global book',
          '"New note" --book "My book" # Edits a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Edits a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]
          path = book.nil? ? "#{default_book}/#{title}.rn" : "#{root_path}/#{book}/#{title}.rn"

          return warn ERRORS[:book_note_not_found] unless File.exist?(path)

          TTY::Editor.open(path)
        end
      end

      class Retitle < Dry::CLI::Command
        include RN::Utils

        desc 'Retitle a note'

        argument :old_title, required: true, desc: 'Current title of the note'
        argument :new_title, required: true, desc: 'New title for the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo TODO                                 # Changes the title of the note titled "todo" from the global book to "TODO"',
          '"New note" "Just a note" --book "My book" # Changes the title of the note titled "New note" from the book "My book" to "Just a note"',
          'thoughts thinking --book Memoires         # Changes the title of the note titled "thoughts" from the book "Memoires" to "thinking"'
        ]

        def call(old_title:, new_title:, **options)
          book = options[:book]

          return warn ERRORS[:invalid_name] unless valid_name?(old_title) || valid_name?(new_title)

          old_path = book.nil? ? default_book + "/#{old_title}.rn" : "#{root_path}/#{book}/#{old_title}.rn"
          new_path = book.nil? ? default_book + "/#{new_title}.rn" : "#{root_path}/#{book}/#{new_title}.rn"

          return warn ERRORS[:note_not_found] unless File.exist?(old_path)

          if File.rename(old_path, new_path)
            puts '¡Nota renombrada exitosamente!'
          else
            puts 'Hubo un problema al renombrar la nota :('
          end
        end
      end

      class List < Dry::CLI::Command
        include RN::Utils

        def print_files(initial_path)
          Dir.foreach(initial_path) do |filename|
            next if ['.', '..'].include?(filename)

            path = "#{initial_path}/#{filename}"
            if File.file?(path)
              puts "-- 🗒️  #{filename}"
            else
              puts "📁  #{filename}"
              print_files(path)
            end
          end
        end

        desc 'List notes'

        option :book, type: :string, desc: 'Book'
        option :global, type: :boolean, default: false, desc: 'List only notes from the global book'

        example [
          '                 # Lists notes from all books (including the global book)',
          '--global         # Lists notes from the global book',
          '--book "My book" # Lists notes from the book named "My book"',
          '--book Memoires  # Lists notes from the book named "Memoires"'
        ]

        def call(**options)
          book = options[:book]
          global = options[:global]

          return warn ERRORS[:book_not_found] unless File.exist?("#{root_path}/#{book}")

          print_files("#{root_path}/#{book}") unless book.nil?
          print_files(default_book) if global
          print_files(root_path) if !global && book.nil?
        end
      end

      class Show < Dry::CLI::Command
        include RN::Utils

        def print_content(title, path)
          puts "Título: #{title}"
          puts ''
          puts 'Contenido:'
          system('cat', path)
        end
        desc 'Show a note'

        argument :title, required: true, desc: 'Title of the note'
        option :book, type: :string, desc: 'Book'

        example [
          'todo                        # Shows a note titled "todo" from the global book',
          '"New note" --book "My book" # Shows a note titled "New note" from the book "My book"',
          'thoughts --book Memoires    # Shows a note titled "thoughts" from the book "Memoires"'
        ]

        def call(title:, **options)
          book = options[:book]

          if book.nil?
            return warn ERRORS[:book_note_not_found] unless File.exist?("#{default_book}/#{title}.rn")

            print_content(title, "#{default_book}/#{title}.rn")
          else
            return warn ERRORS[:book_note_not_found] unless File.exist?("#{root_path}/#{book}/#{title}.rn")

            print_content(title, "#{root_path}/#{book}/#{title}.rn")
          end
        end
      end
    end
  end
end
