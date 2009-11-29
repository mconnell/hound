class CategoriesController < ApplicationController
  before_filter :set_active_navigation

  def index
    @categories = Category.all
    respond_to do |format|
      format.html
    end
  end

  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  private
  def set_active_navigation
    @active_navigation = 'Categories'
  end
end
