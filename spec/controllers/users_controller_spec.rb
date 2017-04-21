require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    it 'renders the show template' do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before(:each) do
        post :create, user: { email: 'whatever@stuff.com', password: 'password' }
      end
      it 'creates a new user' do
        expect(User.last.email).to eq('whatever@stuff.com')
      end
      it 'redirects to the user\'s show page after creation' do
        expect(response).to redirect_to(user_url(User.last.id))
      end
    end

    context 'with invalid params' do
      it 'validates the presence of email' do
        post :create, user: { password: 'password' }
        expect(response).to redirect_to(new_user_url)
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of password' do
        post :create, user: { email: 'whatever@stuff.com' }
        expect(response).to redirect_to(new_user_url)
        expect(flash[:errors]).to be_present
      end
      it 'validates that the password is at least 6 characters long' do
        post :create, user: { email: 'whatever@stuff.com', password: 'pass' }
        expect(response).to redirect_to(new_user_url)
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
