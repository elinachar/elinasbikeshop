require 'rails_helper'

describe SimplePagesController, type: :controller do
  context 'GET #landing_page' do
    it 'renders the landing_page template' do
      get :landing_page
      expect(response).to be_ok
      expect(response).to render_template('landing_page')
    end
  end

  context 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to be_ok
      expect(response).to render_template('index')
    end
  end

  context 'GET #about' do
    it 'renders the about template' do
      get :about
      expect(response).to be_ok
      expect(response).to render_template('about')
    end
  end

  context 'GET #contact' do
    it 'renders the contact template' do
      get :contact
      expect(response).to be_ok
      expect(response).to render_template('contact')
    end
  end


end
