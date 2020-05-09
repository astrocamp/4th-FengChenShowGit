class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :edit, :update, :destroy]

  def index
    if current_user
      @repositories = current_user.repositories.includes(:user)
    else
      redirect_to new_user_session_path
    end
  end

  def show
  end

  def new
    @repository = Repository.new
  end

  def edit
  end

  def create
    @repository = current_user.repositories.new(repository_params)
    
    if @repository.save
      title = @repository.title
      bare_repo_dir = "#{title}.git"

      full_dir = "/Users/godzillalabear/Documents/Astro_Camp/gitServer/#{bare_repo_dir}"

      `mkdir #{full_dir}`
      `git --bare init #{full_dir}`
      redirect_to repositories_path, notice: '已建立新專案！' 
    else
      render :new
    end
  end

  def update
    if @repository.update(repository_params)
      redirect_to repositories_path, notice: '專案內容已更新！'
    else
      render :edit
    end
  end

  def destroy
    @repository.destroy
    redirect_to repositories_path, notice: '專案已刪除！'
  end

  private
    def set_repository
      @repository = Repository.find(params[:id])
      session[:repository_id] = @repository.id
    end

    def repository_params
      params.require(:repository).permit(:title, :description, :user_id)
    end
end