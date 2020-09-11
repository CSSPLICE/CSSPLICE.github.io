# This "hook" is executed right before the site's pages are rendered
Jekyll::Hooks.register :site, :pre_render do |site|
#  puts 'Adding PEML Lexer...'
  require 'rouge'

  module Rouge
    module Lexers
#      class PemlLexer < YAML
#        tag 'peml'
#        title 'PEML'
#        desc 'Program Exercise Markup Language'
#        mimetypes 'text/x-peml'
#        filenames '*.peml'
#      end

      class PemlLexer < RegexLexer
        tag 'peml'
        title 'PEML'
        desc 'Program Exercise Markup Language'
        mimetypes 'text/x-peml'
        filenames '*.peml'
        
        state :root do
          rule %r/^[[:blank:]]*#.*$/, Comment::Single
          rule %r/^[\w\.]+:/, Keyword
          rule %r/^\[[\w\.]*\]/, Keyword::Namespace
          rule %r/\{[\w\.]*\}/, Keyword::Namespace
          rule %r/^:[\w]+/, Keyword::Declaration

          rule %r/(?x)
            (?<delim>(?<char>[[:graph:]])\k<char>{2,})
            (((?!\k<delim>)(.|[\r\n]))*)
            ^\k<delim>[[:blank:]]*$
            /, Literal::String::Heredoc
          rule %r/\{\{[^\}]*\}\}/, Keyword::Constant
          rule %r/<[^>\r\n]*>/, Keyword::Constant

          rule %r/url\([^\)]*\)/, Name::Constant # Operator::Word
          rule %r/\s+/, Text::Whitespace
          rule %r/\S+/, Text
        end

      end
    end
  end
end
