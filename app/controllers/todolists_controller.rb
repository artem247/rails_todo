class TodolistsController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_todolist, only [:show, :update, :destroy]

    #GET /todolists
    def index
        @todolists = current_user.todolists
        render json: @todolists
    end

    #GET /todolists/1
    def show
        render json: @todolist
    end

    #POST /todolists
    def create
        @todolist = current_user.todolists.build(todolist_params)

        if @todolist.save
            render json: @todolist, status: :created, location: @todolist
        else
            render json: @todolist.errors, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /todolists/1
    def update
        if @todolist.update(todolist_params)
            render json: @todolist
        else
            render json: @todolist.errors, status: :unprocessable_entity
        end
    end


    # DELETE /todos/1
    def destroy
        @todolist.destroy
    end

    private

    def set_todolist
        @todolist = current_user.todolists.find(params[:id])
    end

    def todolist_params
        params.require(:todolist).permit(:title)
    end
    
end