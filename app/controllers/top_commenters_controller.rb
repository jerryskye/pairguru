class TopCommentersController < ApplicationController
  def raw_sql
    @top_commenters = User.find_by_sql("select count(user_id) as comment_count, users.id, email, comments.created_at
                                       from users join comments on users.id == comments.user_id
                                       where comments.created_at >= '#{1.week.ago}'
                                       group by user_id
                                       order by count(user_id) desc
                                       limit 10")
  end

  def active_record
    @top_commenters = User.joins(:comments)
      .group(:user_id)
      .select('count(user_id) as comment_count', 'comments.created_at', :email, :id)
      .where('comments.created_at >= ?', 1.week.ago)
      .order('comment_count DESC')
      .limit(10)
  end
end
