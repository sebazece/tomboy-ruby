module RN
  module Commands
    module Books
      ERRORS = {
        invalid_name: 'El nombre del cuaderno es inválido',
        already_exists: 'El cuaderno ya existe',
        not_found: 'El cuaderno no fue encontrado'
      }.freeze

      class Create < Dry::CLI::Command
        include RN::Utils

        desc 'Create a book'

        argument :name, required: true, desc: 'Name of the book'

        example [
          '"My book" # Creates a new book named "My book"',
          'Memoires  # Creates a new book named "Memoires"'
        ]

        def call(name:, **)
          return warn ERRORS[:invalid_name] unless valid_name?(name)

          path = "#{root_path}/#{name}"
          return warn ERRORS[:already_exists] if File.exist?(path)

          Dir.mkdir(path)
        end
      end

      class Delete < Dry::CLI::Command
        include RN::Utils
        require 'fileutils'

        def delete_notes_from_global_book
          Dir.foreach(default_book) do |filename|
            next if filename == '.' or filename == '..'

            filename_path = "#{default_book}/#{filename}"
            FileUtils.rm(filename_path)
          end

          puts 'Notas del cuaderno global eliminadas exitosamente'
        end

        desc 'Delete a book'

        argument :name, required: false, desc: 'Name of the book'
        option :global, type: :boolean, default: false, desc: 'Operate on the global book'

        example [
          '--global  # Deletes all notes from the global book',
          '"My book" # Deletes a book named "My book" and all of its notes',
          'Memoires  # Deletes a book named "Memoires" and all of its notes'
        ]

        def call(name: nil, **options)
          global = options[:global]

          delete_notes_from_global_book if global

          return warn ERRORS[:invalid_name] unless valid_name?(name)

          path = "#{root_path}/#{name}"

          return warn ERRORS[:not_found] unless File.exist?(path)

          FileUtils.rm_rf(path)
          puts "¡Cuaderno #{name} y sus notas eliminados exitosamente!"
        end
      end

      class List < Dry::CLI::Command
        include RN::Utils

        def print_book
          Dir.foreach(root_path) do |filename|
            next if ['.', '..'].include?(filename)

            path = "#{root_path}/#{filename}"
            puts "📁  #{filename}" if File.directory?(path)
          end
        end

        desc 'List books'

        example [
          '          # Lists every available book'
        ]

        def call(*)
          print_book
        end
      end

      class Rename < Dry::CLI::Command
        include RN::Utils

        desc 'Rename a book'

        argument :old_name, required: true, desc: 'Current name of the book'
        argument :new_name, required: true, desc: 'New name of the book'

        example [
          '"My book" "Our book"         # Renames the book "My book" to "Our book"',
          'Memoires Memories            # Renames the book "Memoires" to "Memories"',
          '"TODO - Name this book" Wiki # Renames the book "TODO - Name this book" to "Wiki"'
        ]

        def call(old_name:, new_name:, **)
          return warn ERRORS[:invalid_name] unless valid_name?(old_name) || valid_name?(new_name)

          old_path = "#{root_path}/#{old_name}"
          new_path = "#{root_path}/#{new_name}"

          return warn ERRORS[:already_exists] if File.exist?(new_path)

          return warn ERRORS[:not_found] unless File.exist?(old_path)

          File.rename(old_path, new_path)
          puts '¡Cambio de nombre exitoso!'
        end
      end
    end
  end
end
