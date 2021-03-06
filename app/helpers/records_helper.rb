module RecordsHelper

  def fix_long_word(word)
    i = 50
    while word.size > i
      word.insert(i - 5, ' ')
      i += 45
    end
    word
  end

  def fix_long_words(content)
    words = content.split(' ')
    for word in words
      fix_long_word(word)
    end
    words.join(' ')
  end

  def selected?
    if @record.type.nil?
      'A'
    else
      @record.type
    end
  end

end
