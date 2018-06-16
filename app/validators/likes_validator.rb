class LikesValidator

  def self.validate(movie:, user:)
    not Like.exists?(:user => user, :movie => movie)
  end
end
