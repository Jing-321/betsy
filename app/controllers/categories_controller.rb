class CategoriesController < ApplicationController

  before_action :find_category, only: :show


  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfully created #{@category.name}"
      redirect_to manage_tours_path
      return
    else
      flash[:error] = "Could not create new category: #{@category.errors.messages}"
      render :new, status: :bad_request
      return
    end
  end

  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      flash[:error] = "Could not find Category"
      redirect_to root_path
      # return render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
    return @category
  end
end
