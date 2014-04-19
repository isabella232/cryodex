module SymeShowcase

  class Base < Sinatra::Base

    # Recursive inline eval of Ruby files.
    def self.require_all(dir, opts={})
      Dir["./#{dir}/**/*.rb"].each do |f|
        next if f.index('deploy') || f =~ /^_/
        eval(File.read f)
      end
    end

  end

end