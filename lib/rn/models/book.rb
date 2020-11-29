module RN
  module Models
    class Book
      include RN::Utils

      ERRORS = {
        invalid_name: 'El nombre del cuaderno es inválido',
        already_exists: 'El cuaderno ya existe',
        not_found: 'El cuaderno no fue encontrado'
      }.freeze

      def create(name)
        return warn ERRORS[:invalid_name] unless valid_name?(name)

        path = "#{root_path}/#{name}"
        return warn ERRORS[:already_exists] if File.exist?(path)

        Dir.mkdir(path)
        puts '¡Cuaderno creado exitosamente!'
      end

      def delete(name, global)
        delete_notes_from_global_book if global

        return warn ERRORS[:invalid_name] unless valid_name?(name)

        path = "#{root_path}/#{name}"

        return warn ERRORS[:not_found] unless File.exist?(path)

        FileUtils.rm_rf(path)
        puts "¡Cuaderno #{name} y sus notas eliminados exitosamente!"
      end

      def list
        print_book
      end

      def rename(old_name, new_name)
        return warn ERRORS[:invalid_name] unless valid_name?(old_name) || valid_name?(new_name)

        old_path = "#{root_path}/#{old_name}"
        new_path = "#{root_path}/#{new_name}"

        return warn ERRORS[:already_exists] if File.exist?(new_path)

        return warn ERRORS[:not_found] unless File.exist?(old_path)

        File.rename(old_path, new_path)
        puts '¡Cambio de nombre exitoso!'
      end

      private

      def delete_notes_from_global_book
        Dir.foreach(default_book_path) do |filename|
          next if filename == '.' or filename == '..'

          filename_path = "#{default_book_path}/#{filename}"
          FileUtils.rm(filename_path)
        end

        puts 'Notas del cuaderno global eliminadas exitosamente'
      end

      def print_book
        Dir.foreach(root_path) do |filename|
          next if ['.', '..'].include?(filename)

          path = "#{root_path}/#{filename}"
          puts "📁  #{filename}" if File.directory?(path)
        end
      end
    end
  end
end
