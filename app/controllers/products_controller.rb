class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  # before_action :check_authorization, only: [:edit, :update, :retire]


  def index
    @products = Product.where(active: true)
  end

  def show
    # session[:product] = @product # will allow to add a review for that product, not sure if it's right
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = session[:user_id]

    if @product.save
      flash[:success] = "#{@product.name} has been added to the tour list"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something happened, could not create tour: #{@product.format_errors}"
      render :new, status: :bad_request
      return
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      flash[:success] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something is wrong. Could not update tour: #{@product.format_errors}"
      render :edit, status: :bad_request
      return
    end
  end

  def add_to_cart
    #find product by the id passed in params
    # product.find_by(id: params[:id])
    # return head :not_found if !product
  end

  def retire
    if @product.retire
      if @product.active == true
        flash[:success] = "#{@product.name} is now active and will appear on searches."
      else
        flash[:success] = "#{@product.name} is now retired and won't appear on searches."
      end
      redirect_to product_path(@product.id)
    end
  end

  # def destroy
  #   @product.destroy
  #   flash[:success] = "#{@product.name} has been deleted."
  #   #todo: what is the correct pathway here?
  #   redirect_to current_merchant_path #check terms
  #   return
  # end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :stock, :status, :active, category_ids: []) #user_id
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:error] = "Tour not found"
      redirect_to products_path
      return
    end
    return @product
  end


end
