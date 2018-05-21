require "rails_helper"

describe "Movies requests", type: :request do
  describe "movies list" do
    it "displays right title" do
      visit "/movies"
      expect(page).to have_selector("h1", text: "Movies")
    end
  end

  describe "show movie" do
    subject { create(:movie) }
    let(:user) { create(:user) }

    it "displays right title" do
      visit movie_path(subject)
      expect(page).to have_selector("h1", text: subject.title)
    end

    it "displays all comments" do
      comments = create_list(:comment, 2, movie: subject)
      visit movie_path(subject)
      comments.each do |comment|
        expect(page).to have_selector("p", text: comment.body)
      end
    end

    it "lets a logged in user add a comment" do
      sign_in(user)
      visit movie_path(subject)
      expect(page).to have_button("Add comment")
      fill_in('comment_body', with: Faker::Lorem.sentence)
      expect { click_button 'Add comment' }.to change(Comment, :count)
    end

    it "shouldn't let a user add a comment without previous login" do
      visit movie_path(subject)
      expect(page).to have_no_button("Add comment")
    end

    it "informs a user that he can post only one comment" do
      create(:comment, movie: subject, author: user)
      sign_in(user)
      visit movie_path(subject)
      expect(page).to have_selector("p", text: "Sorry, you can only post one comment on a movie. You can remove your existing comment here")
    end

    it "lets a user delete his previous comment" do
      create(:comment, movie: subject, author: user)
      sign_in(user)
      visit movie_path(subject)
      expect(page).to have_link("here", href: remove_comment_movie_path(subject))
      expect { click_link 'here' }.to change(Comment, :count)
    end
  end
end
