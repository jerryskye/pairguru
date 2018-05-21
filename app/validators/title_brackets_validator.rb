class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    bracket_mapping = {'[' => ']', '{' => '}', '(' => ')'}
    bracket_stack = []
    just_entered = false
    record.title.each_char do |char|
      case char
      when '[', '{', '('
        just_entered = true
        bracket_stack.push(char)
      when ']', '}', ')'
        last_bracket = bracket_stack.pop
        return invalid_title(record) if just_entered or char != bracket_mapping[last_bracket]
        just_entered = false
      else
        just_entered = false
      end
    end
    invalid_title(record) unless bracket_stack.empty?
  end

  private
  def invalid_title(record)
    record.errors.add(:title, 'has invalid bracket configuration')
  end
end
