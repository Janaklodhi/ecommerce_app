# spec/controllers/articles_controller_spec.rb
require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      byebug
      expect(response).to have_http_status(:success)
    end
  end
end
