module RN
  module Models
    class Export
      require 'pandoc-ruby'

      include RN::Utils

      ERRORS = {
        invalid_name: 'El nombre de la nota o cuaderno es inválido',
        book_not_found: 'Cuaderno no encontrado',
        note_not_found: 'Nota no encontrada',
        book_not_given: 'Debe especificar el nombre del cuaderno a exportar'
      }.freeze

      def note(title, book)
        return warn ERRORS[:invalid_name] unless valid_name?(title)

        book_path = book.nil? ? default_book_path : "#{root_path}/#{book}"

        return warn ERRORS[:book_not_found] unless File.exist?(book_path)

        return warn ERRORS[:note_not_found] unless File.exist?("#{book_path}/#{title}.rn")

        markdown_file = File.open("#{book_path}/#{title}.rn")
        converter = PandocRuby.new(markdown_file.read, from: :markdown, to: :pdf)

        pdf_file_path = book_path + "/#{title}.pdf"
        export_file(pdf_file_path, converter)
        puts "Nota #{title} exportada exitosamente"
        puts 'IMPORTANTE: El pdf generado se encuentra en el mismo cuaderno que el archivo original'
      end

      def book(book, global)
        return export_notes(default_book_path) if global

        return warn ERRORS[:book_not_given] if book.nil?

        book_path = "#{root_path}/#{book}"

        return warn ERRORS[:book_not_found] unless File.exist?(book_path)

        export_notes(book_path)
      end

      def all
        Dir.foreach(root_path) do |filename|
          next if ['.', '..'].include?(filename)

          path = "#{root_path}/#{filename}"
          export_notes(path)
        end
      end

      def export_notes(book_path)
        Dir.foreach(book_path) do |filename|
          next if ['.', '..'].include?(filename) || pdf_file?(filename)

          markdown_path = "#{book_path}/#{filename}"
          markdown_file = File.open(markdown_path)
          pdf_file_path = "#{markdown_path.delete_suffix('.rn')}.pdf"
          converter = PandocRuby.new(markdown_file.read, from: :markdown, to: :pdf)

          export_file(pdf_file_path, converter)

          puts "Nota #{filename} exportada exitosamente"
          puts 'IMPORTANTE: El pdf generado se encuentra en el mismo cuaderno que el archivo original'
        end
      end

      def pdf_file?(filename)
        File.extname(filename) == '.pdf'
      end
    end
  end
end
