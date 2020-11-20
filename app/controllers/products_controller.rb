class ProductsController < ApplicationController

  # before_action :verify_merchant, only: [:edit, :update, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  # skip_before_action :require_login, only: [:root, :show, :index]

  def index
    @products = Product.all
  end

  def show
    # session[:product] = @product # will allow to add a review for that product, not sure if it's right
  end

  def new
    @product = Product.new
  end

  def create
    # @product.merchant_id = session[:merchant_id]
    @product = Product.new(product_params)

    if @product.save
      flash[:success] = "#{@product.name} has been added to the products list"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something happened. #{@product.name} could not be added to the products list."
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
      flash.now[:error] = "Something is wrong. Could not update #{@product.name}."
      render :edit, status: :bad_request
      return
    end
  end

  def add_to_cart
    #find product by the id passed in params
    # product.find_by(id: params[:id])
    # return head :not_found if !product
  end



  # todo is destroy necessary for products or just retire?
  def destroy
    @product.destroy
    flash[:success] = "#{@product.name} has been deleted."
    #todo: what is the correct pathway here?
    redirect_to current_merchant_path #check terms
    return
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :stock, :status, category_ids: []) #:creator, :inventory, :category_id: []
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      # todo figure out best way to display message or where to send user?
      flash[:error] = "Product not found."
      redirect_to products_path
      return
    end
    return @product
  end


end
