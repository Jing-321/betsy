class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # def show
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  # end

  def new
    @review = Review.new
  end

  # def edit
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  # end

  def create
    #How do we know what the guest user_id is???
    @user = User.find(session[:user_id])
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)

    if @review.save
      flash[:notice] = 'Review was successfully created.'
      redirect_to @product
    else
      flash[:notice] = "Error creating review: #{@review.errors}"
      redirect_to @product
    end
  end

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

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :text_review)
  end
end
