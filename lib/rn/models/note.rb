module RN
  module Models
    class Note
      include RN::Utils

      ERRORS = {
        invalid_name: 'El nombre de la nota es inválido',
        book_not_found: 'Cuaderno no encontrado',
        note_not_found: 'Nota no encontrada',
        book_note_not_found: 'El cuaderno o nota no existe',
        alredy_exists: 'Ya existe una nota con ese título'
      }.freeze

      def create(title, book)
        return warn ERRORS[:invalid_name] unless valid_name?(title)

        path = book.nil? ? default_book_path : "#{root_path}/#{book}"

        return warn ERRORS[:book_not_found] unless File.exist?(path)

        return warn ERRORS[:alredy_exists] if File.exist?(path + "/#{title}.rn")

        TTY::Editor.open(path + "/#{title}.rn")
        puts '!Nota creada exitosamente!'
      end

      def delete(title, book)
        path = book.nil? ? "#{default_book_path}/#{title}.rn" : "#{root_path}/#{book}/#{title}.rn"

        return warn ERRORS[:book_note_not_found] unless File.exist?(path)

        File.delete(path)

        puts '¡Nota eliminada exitosamente!'
      end

      def edit(title, book)
        path = book.nil? ? "#{default_book_path}/#{title}.rn" : "#{root_path}/#{book}/#{title}.rn"

        return warn ERRORS[:book_note_not_found] unless File.exist?(path)

        TTY::Editor.open(path)
      end

      def retitle(old_title, new_title, book)
        return warn ERRORS[:invalid_name] unless valid_name?(old_title) || valid_name?(new_title)

        old_path = book.nil? ? default_book_path + "/#{old_title}.rn" : "#{root_path}/#{book}/#{old_title}.rn"
        new_path = book.nil? ? default_book_path + "/#{new_title}.rn" : "#{root_path}/#{book}/#{new_title}.rn"

        return warn ERRORS[:note_not_found] unless File.exist?(old_path)

        if File.rename(old_path, new_path)
          puts '¡Nota renombrada exitosamente!'
        else
          puts 'Hubo un problema al renombrar la nota :('
        end
      end

      def list(book, global)
        return warn ERRORS[:book_not_found] unless File.exist?("#{root_path}/#{book}")

        print_files("#{root_path}/#{book}") unless book.nil?
        print_files(default_book_path) if global
        print_files(root_path) if !global && book.nil?
      end

      def show(title, book)
        if book.nil?
          return warn ERRORS[:book_note_not_found] unless File.exist?("#{default_book_path}/#{title}.rn")

          print_content(title, "#{default_book_path}/#{title}.rn")
        else
          return warn ERRORS[:book_note_not_found] unless File.exist?("#{root_path}/#{book}/#{title}.rn")

          print_content(title, "#{root_path}/#{book}/#{title}.rn")
        end
      end

      private

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

      def print_content(title, path)
        puts "Título: #{title}"
        puts ''
        puts 'Contenido:'
        system('cat', path)
      end
    end
  end
end