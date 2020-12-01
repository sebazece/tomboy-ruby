module RN
  module Commands
    autoload :Books, 'rn/commands/books'
    autoload :Notes, 'rn/commands/notes'
    autoload :Exports, 'rn/commands/exports'
    autoload :Version, 'rn/commands/version'

    extend Dry::CLI::Registry

    register 'books', aliases: ['b'] do |prefix|
      prefix.register 'create', Books::Create
      prefix.register 'delete', Books::Delete
      prefix.register 'list', Books::List
      prefix.register 'rename', Books::Rename
    end

    register 'notes', aliases: ['n'] do |prefix|
      prefix.register 'create', Notes::Create
      prefix.register 'delete', Notes::Delete
      prefix.register 'retitle', Notes::Retitle
      prefix.register 'edit', Notes::Edit
      prefix.register 'list', Notes::List
      prefix.register 'show', Notes::Show
    end

    register 'exports', aliases: ['exp'] do |prefix|
      prefix.register 'note', Exports::Note
      prefix.register 'book', Exports::Book
      prefix.register 'all', Exports::All
    end

    register 'version', Version, aliases: ['v', '-v', '--version']
  end
end
