require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  describe 'GET #new' do
    it 'should render the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
  describe 'GET #edit' do
    it 'should render the edit template' do
      goal = Goal.create(title: 'A',
                  description: 'B',
                  target_date: Date.today,
                  public_goal: true)
      get :edit, params: { id: goal.id }
      expect(response).to render_template(:edit)
    end
  end
  describe 'POST #create' do
    context 'with valid params' do
      before(:each) do
        post :create, params: { goal: { title: 'A',
                                        description: 'B',
                                        target_date: Date.today,
                                        public_goal: true },
                                user_id: 1 }
      end
      it 'creates a new goal' do
        expect(Goal.last.title).to eq('A')
        expect(Goal.last.description).to eq('B')
        expect(Goal.last.target_date).to eq(Date.today)
        expect(Goal.last.public_goal).to eq(true)
      end
      it 'redirects to the user\'s page' do
        expect(response).to redirect_to(user_url(chris))
      end
    end
    context 'with invalid params' do
      it 'validates the presence of title' do
        post :create, params: { goal: { description: 'B',
                                        target_date: Date.today,
                                        public_goal: true },
                                user_id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of description' do
        post :create, params: { goal: { title: 'B',
                                        target_date: Date.today,
                                        public_goal: true },
                                user_id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of target_date' do
        post :create, params: { goal: { title: 'A',
                                        description: 'B',
                                        public_goal: true },
                                user_id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
    end
  end
  describe 'PATCH #update' do
    context 'with valid params' do
      before(:each) do
        patch :update, params: { goal: { title: 'B',
                                         description: 'C',
                                         target_date: Date.tomorrow,
                                         public_goal: false },
                                 id: 1 }
      end
      it 'edits the chosen goal' do
        expect(Goal.find(1).title).to eq('B')
        expect(Goal.find(1).description).to eq('C')
        expect(Goal.find(1).target_date).to eq(Date.tomorrow)
        expect(Goal.find(1).public_goal).to eq(false)
      end
      it 'redirects to the user\'s page' do
        expect(response).to redirect_to(user_url(Goal.find(1).user))
      end
    end
    context 'with invalid params' do
      it 'validates the presence of title' do
        patch :update, params: { goal: { description: 'C',
                                         target_date: Date.tomorrow,
                                         public_goal: false },
                                 id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of description' do
        patch :update, params: { goal: { title: 'B',
                                         target_date: Date.tomorrow,
                                         public_goal: false },
                                 id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
      it 'validates the presence of target_date' do
        patch :update, params: { goal: { title: 'B',
                                         description: 'C',
                                         public_goal: false },
                                 id: 1 }
        expect(response).to redirect_to(user_url(chris))
        expect(flash[:errors]).to be_present
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'deletes goal' do
      delete :destroy, params: { id: 1 }
      expect(Goal.find_by(id: 1)).to eq(nil)
    end
  end
end
