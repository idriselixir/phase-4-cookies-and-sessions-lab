class ArticlesController < ApplicationController
  before_action :initialize_page_views
  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] += 1

    if session[:page_views] <= 3
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  def initialize_page_views
    session[:page_views] ||= 0
  end
end
