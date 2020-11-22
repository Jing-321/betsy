class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # def show
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  # end

  def new
    # if params[:product_id]
    #  @product = Product.find_by(id: params[:product_id])
    #  check_authorization
    #  @review = @product.reviews.new
    #  end
    @review = Review.new

  end

  def create
    #How do we know what the guest user_id is???
    @product = Product.find(params[:product_id])

    @review = Review.new(review_params)
    @review.product = @product
    check_authorization
    if @review.save
      flash[:success] = 'Review was successfully created.'
      redirect_to product_path(@product)
    else
      flash[:error] = "Error creating review: #{@review.errors}"
      redirect_to product_path(@product)
    end
  end



  # def edit
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  # end
  # def update
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  #
  #   if @review.update_attributes(params[:review])
  #     flash[:notice] = "Review updated"
  #     redirect_to @product
  #   else
  #     flash[:error] = "There was an error updating your review"
  #     redirect_to @product
  #   end
  # end

  # def destroy
  #   @product = Product.find(params[:picture_id])
  #   @review = Review.find(params[:id])
  #   @review.destroy
  #   redirect_to(@review.post)
  # end
  def check_authorization
    @user = User.find_by(id: session[:user_id])
    if @product.user_id == @user_id && @user != nil
      flash[:warning] = "You cannot review your own product"
      redirect_to 'products/index' # => we can change this based on the usage
      return
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :text_review)
  end
end
