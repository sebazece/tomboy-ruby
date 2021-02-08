module Backend
  require 'zip'
  class ExportsController < BackendController
    def note
      note = Note.find(params[:id])
      converter = PandocRuby.new(note.body, from: :markdown, to: :pdf)
      tmp_path = Rails.root.join("tmp/#{note.title}.pdf")
      File.open(tmp_path, 'w') { |f| f.puts converter.convert }
      send_file tmp_path, type: 'application/pdf', x_sendfile: true
    end

    def book
      book = params[:id] == 'nil' ? OpenStruct.new(name: 'Notas sin cuaderno') : Book.find(params[:id])
      notes = Note.by_user(current_user.id).where(book: params[:id] == 'nil' ? nil : book)
      input_filenames = []

      notes.each do |note|
        tmp_path = Rails.root.join("tmp/#{note.title}.pdf")
        f = File.new(tmp_path, 'a')
        input_filenames << "#{note.title}.pdf"
        converter = PandocRuby.new(note.body, from: :markdown, to: :pdf)
        f.write(converter.convert)
        f.close
      end

      folder = Rails.root.join('tmp')
      zipfile_name = Rails.root.join("tmp/#{book.name}.zip")

      File.delete(Rails.root.join("tmp/#{book.name}.zip")) if File.exist?(Rails.root.join("tmp/#{book.name}.zip"))

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, File.join(folder, filename))
        end
      end
      input_filenames.each { |filename| File.delete(Rails.root.join("tmp/#{filename}")) }
      send_file zipfile_name
    end

    def all
      notes = Note.by_user(current_user.id)
      input_filenames = []
      notes.each do |note|
        book_name = note.book.nil? ? '(Nota si cuaderno)' : note.book.name
        tmp_path = Rails.root.join("tmp/#{note.title} - Cuaderno: #{book_name}.pdf")
        f = File.new(tmp_path, 'a')
        input_filenames << "#{note.title} - Cuaderno: #{book_name}.pdf"
        converter = PandocRuby.new(note.body, from: :markdown, to: :pdf)
        f.write(converter.convert)
        f.close
      end
      folder = Rails.root.join('tmp')
      zipfile_name = Rails.root.join('tmp/Todas las notas.zip')
      File.delete(Rails.root.join('tmp/Todas las notas.zip')) if File.exist?(Rails.root.join('tmp/Todas las notas.zip'))
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, File.join(folder, filename))
        end
      end
      input_filenames.each { |filename| File.delete(Rails.root.join("tmp/#{filename}")) }
      send_file zipfile_name
    end
  end
end