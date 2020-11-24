class ReviewsController < ApplicationController
  # before_action :check_authorization, only: [:new, :create]

  # def show
  #   @product = Product.find(params[:product_id])
  #   @review = Review.find(params[:id])
  # end

  def new
    @product = Product.find(params[:product_id])

    check_authorization(@product)
    @review = Review.new
    # @review = @product.reviews.new
  end

  def create
    @product = Product.find(params[:product_id])

    check_authorization(@product)
    @review = Review.new(review_params)
    @review.product = @product
    if @review.save
      flash[:success] = 'Review was successfully created.'
      redirect_to product_path(@product)
      return
    else
      flash[:error] = "Error creating review: #{@review.format_errors}"
      redirect_to product_path(@product)
      return
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
  def check_authorization(product)
    @user = User.find_by(id: session[:user_id])
    if product.user_id == @user.id && @user != nil
      flash[:error] = "You cannot review your own product"
      redirect_to product_path(product) # => we can change this based on the usage
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
