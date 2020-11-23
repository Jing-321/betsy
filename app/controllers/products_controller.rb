class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]
  before_action :check_authorization, only: [:edit, :update, :retire]


  def index
    @products = Product.where(active: true)
  end

  def show
    #@products = Product.where(active: true)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = User.find_by(id: session[:user_id])

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

  def edit ; end

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
    product = Product.find_by(id: params[:id])
    if product.nil? || !product
      return head :not_found
    end

    if session[:order_id] == nil || session[:order_id] == false
         order = Order.new(status: "pending")
         session[:order_id] = order.id
    end

    if session[:order_id] && session[:order_id].products.include?(product)
      order_item = OrderItem.new(
          quantity: 0,
          product_id: product.id,
          order_id: session[:order_id]
      )
    end

    #if qty > stock + current qty, don't save
    if params[:quantity].to_i > (product.stock - order_item.quantity)
      flash[:error] = "#{product.name} is low in stock and was not added to cart."
      redirect_to product_path(product.id)
      return
    else
      order_item.quantity += params[:quantity].to_i
      order_item.save
      flash[:success] = "#{product.name} added to cart."
      redirect_to product_path(product.id)
      return
    end
  end

  def retire
    if @product.retire
      if @product.active # == true
        @product.update(active: false)
        flash[:success] = "#{@product.name} is now retired and won't appear on searches."
        redirect_to product_path(@product.id)
      else
        @product.update(active: true)
        flash[:success] = "#{@product.name} is now active and will appear on searches."
      end
      redirect_to product_path(@product.id)
    end
  end

  def explore
    @products = Product.where(active: true).get_top_rated
  end

  def destroy; end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :stock, :photo_url, active: true, category_ids: []) #user_id ??
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

  def check_authorization
    if @product.user_id != session[:user_id]
      flash.now[:warning] = "You are not authorized to view this page."
      render 'products/index', status: :unauthorized
      return
    end
  end

end
