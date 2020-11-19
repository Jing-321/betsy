class CategoriesController < ApplicationController

  before_action :find_category, only: [:show]

  def index
    @categories = Category.all
  end

  def show
    if @category.nil?
      flash[:error]
      redirect_back fallback_location: root_path
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfully created #{@category.name}"
      # not sure if this will redirect to where user was prior to the form
      # where will user add category? user show page?
      redirect_back fallback_location: root_path
      return
    else
      flash[:error] = "Could not create new category: #{@category.errors.message}"
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:work).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
  end
end
