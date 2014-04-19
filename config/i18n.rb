class Translations

  @@translations = {}

  def self.load(path)
    files = Dir.glob(File.join(path, '*.json'))
    files.each do |file|
      json = JSON.parse(File.read(file))
      @@translations.reverse_merge!(json)
    end
  end

  def self.translate(path, *args)

    parts = path.to_s.split('.') + ['en']

    working = @@translations

    parts.each do |part|
      begin
        working = working[part]
      rescue
        raise "Undefined translation #{path}"
      end
    end

    working % args
  end

end

Translations.load( File.join(settings.root, 'config', 'locales'))