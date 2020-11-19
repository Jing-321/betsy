class CategoriesController < ApplicationController

  before_action :find_category, only: [:show, :destroy]

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Successfully created #{@category.name}"
      # not sure if this will redirect to where user was prior to the form
      # todo where will user add category? user show page?
      redirect_back fallback_location: root_path
      return
    else
      flash[:error] = "Could not create new category: #{@category.errors.messages}"
      render :new, status: :bad_request
      return
    end
  end

  def destroy
    @category.delete
    flash[:success] = "#{@category.name} was successfully deleted"
    return redirect_back fallback_location: root_path
  end


  private

  def category_params
    return params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    if @category.nil?
      # flash[:error]
      return render file: "#{Rails.root}/public/404.html",  layout: false, status: :not_found
    end
    return @category
  end
end
