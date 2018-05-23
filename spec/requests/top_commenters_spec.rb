require "rails_helper"

describe 'Top commenters requests', type: :request do

  shared_examples 'has correct data' do
    it 'should have valid data' do
      no_of_comments_created = 12
      users = create_list(:user, rand(no_of_comments_created) + 1)
      no_of_comments_created.times do
        create(:comment, author: users.sample)
      end
      visit path_to_visit
      expect(page).to have_table
      rows = page.all 'tbody tr'
      page.all('tbody tr').each do |row|
        email, comment_count = row.find_css('td').map {|td| td.visible_text}
        expected_count = User.find_by(email: email).comments.where('created_at >= ?', 1.week.ago).count
        expect(comment_count.to_i).to be(expected_count)
      end
    end
  end

  describe 'using ActiveRecord' do
    let(:path_to_visit) { top_commenters_active_record_path }
    it 'has correct links' do
      visit path_to_visit
      expect(page).to have_link('using ActiveRecord', href: '#')
      expect(page).to have_link('using raw SQL', href: top_commenters_raw_sql_path)
    end

    it_behaves_like 'has correct data'
  end

  describe 'using raw SQL' do
    let(:path_to_visit) { top_commenters_raw_sql_path }
    it 'has correct links' do
      visit top_commenters_raw_sql_path
      expect(page).to have_link('using ActiveRecord', href: top_commenters_active_record_path)
      expect(page).to have_link('using raw SQL', href: '#')
    end

    it_behaves_like 'has correct data'
  end
end
