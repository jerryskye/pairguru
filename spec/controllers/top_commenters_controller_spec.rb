require 'rails_helper'

RSpec.describe TopCommentersController, type: :controller do

  describe "GET #raw_sql" do
    it "returns http success" do
      get :raw_sql
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #active_record" do
    it "returns http success" do
      get :active_record
      expect(response).to have_http_status(:success)
    end
  end

end
