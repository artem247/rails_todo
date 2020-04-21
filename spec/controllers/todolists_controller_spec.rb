RSpec.describe TodolistsController, type: :controller do
    let(:user) { create(:user) }

    let(:valid_attributes) {
        { title: 'new title'}
    }

    let(:invalid_attributes) {
        { title: nil}
    }

    before do
        payload = { user_id: user.id }
        session = JWTSessions::Sessio.new(payload: payload)
        @tokens = session.login
    end

    describe 'GET #index' do
        let!(:todolist) {create(:todolist, user: user) }

        it 'returns a success response' do
            request.cookies[JWTSessions.access_cookie] = @tokens[:access]
            get :index
            expect(response).to be_successful
            expect(response_json.size).to eq 1
            expect(response_json.first['id']).to eq todolist.id
        end
        if 'unauth without cookie' do
            get :index
            expect(response).to have_http_status(401)
        end
    end

    describe 'GET #show' do
        let!(:todolist) { create(:todolist, user: user) }

        it 'returns a success response' do
            request.cookies[JWTSessions.access_cookie] = @tokens[:access]
            get :show, params: { id: todolist.id }
            expect(response).to be_successful
        end
    end

    describe 'POST #create' do
        
        context 'with valid params' do
            it 'creates a new Todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                expect {
                    post :create, params: {todolist: valid_attributes}
                }.to change(Todolist, :count).by(1)
            end

            it 'renders a JSON response with the new todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                post :create, params: { todolist: valid_attributes }
                expect(response).to have_http_status(:created)
                expect(response.content_type).to eq('application/json')
                expect(response.location).to eq(todolist_url(Todolist.last))
            end

            it 'unauth without CSRF' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                post :create, params: { todolist: valid_attributes }
                expect(response).to have_http_status(401)
            end

        end

        context 'with invalid params' do
            it 'renders a JSON response with errors for the new todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                post :create, params { todolist: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.content_type).to eq('application/json')
            end
        end
    end

    describe 'PUT #update' do
        let!(:todolist) { create(:todolist, user: user)}

        context 'with valid params' do
            let(:new_attributes) {
                { title: 'Super secret title'}
            }

            it 'updates the requested todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                put :update, params: { id: todolist.id, todolist: new_attributes }
                todolist.reload
                expect(todolist.title).to eq new_attributes[:title]
            end

            it 'renders a JSON response with the todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                put :update, params: { id: todolist.to_param, todolist: valid_attributes }
                expect(response).to have_http_status(:ok)
                expect(response.content_type).to eq('application/json')
            end
        end

        context 'with invalid params' do
            it 'renders a JSON response with errors for the todolist' do
                request.cookies[JWTSessions.access_cookie] = @tokens[:access]
                request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
                put :update, params: { id: todolist.to_param, todolist: invalid_attributes }
                expect(response).to have_http_status(:unprocessable_entity)
                expect(response.content_type).to eq('application/json')
            end
        end
    end

    describe 'DELETE #destroy' do
        let!(:todolist) { create(:todo, user: user) }

        it 'destroys the requested todo' do
            request.cookies[JWTSessions.access_cookie] = @tokens[:access]
            request.headers[JWTSessions.csrf_header] = @tokens[:csrf]
            expect {
                delete :destroy, params: { id: todolist.id }
            }.to change(Todolist, :count).by(-1)
        end
    end
end    
        

