class ProductsController < ApplicationController

  before_action :verify_merchant, only: [:edit, :update, :destroy]
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  skip_before_action :require_login, only: [:root, :show, :index]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    session[:product] = @product # will allow to add a review for that product, not sure if it's right

    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = session[:merchant_id]

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

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path
      return
    end
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product.id)
      return
    else
      flash.now[:error] = "Something is wrong. Could not update #{@product.name}."
      render :edit
      return
    end
  end

  def add_to_cart
    #find product by the id passed in params
    # product.find_by(id: params[:id])
    # return head :not_found if !product
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:error] = "Product not found."
      redirect_to products_path
      return
    end
    return @product
  end

  def destroy
    @product.destroy
    flash[:success] = "#{@product.name} has been deleted."
    redirect_to current_merchant_path #check terms
    return
  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :stock, category_ids: [], :status) #:creator, :inventory, :category_id: []
  end


end
