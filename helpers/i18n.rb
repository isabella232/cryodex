# Shortcuts for in-template translating

def translate(word, *args)
  Translations.translate(word, *args)
end

alias :t :translate