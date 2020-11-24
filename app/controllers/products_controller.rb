class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy, :retire]
  before_action :check_authorization, only: [:edit, :update, :retire]
  #there should be a before action requirement for login


  def index
    @products = Product.where(active: true)
  end

  def show
    @products = Product.where(active: true)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = User.find_by(id: session[:user_id])
    @product.active = true

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
      flash.now[:error] = "Something is wrong. Could not update tour: #{@product.format_errors}"
      render :edit, status: :bad_request
      return
    end
  end

  def add_to_cart
    @product = Product.find(params[:id])
    if @product.nil? || !@product
      return head :not_found
    end
    if session[:user_id].nil?
      guest = User.create!(username: "guest")
      session[:user_id] = guest.id
    end

    if session[:order_id] == nil || session[:order_id] == false
         order = Order.create!(user_id: session[:user_id], status: "pending")
         session[:order_id] = order.id

         OrderItem.create(
             quantity: 1,
             product_id: @product.id,
             order_id: session[:order_id]
         )
         flash[:success] = "#{@product.name} is added to your cart:)"
         redirect_to shopping_cart_path
    else
      order = Order.find_by(id: session[:order_id])
      if order.order_items.empty?
        OrderItem.create(
            quantity: 1,
            product_id: @product.id,
            order_id: session[:order_id]
        )
        flash[:success] = "#{@product.name} is added to your cart."
        redirect_to shopping_cart_path
      else
        order_item = order.order_items.find{|item| item.product_id == @product.id}

        if order_item
          if @product.stock > 0
            order_item.quantity += 1
          else
            flash[:error] = "Sorry, #{@product.name} is out of stock."
            return redirect_to product_path(@product.id)
          end

          if order_item.save
            flash[:success] = "#{@product.name} is added to your cart  :)"
            redirect_to shopping_cart_path
            return
          else
            flash[:error] = "Oops, #{@product.name} can't be added to your cart."
            redirect_to product_path(@product.id)
            return
          end
        else
          OrderItem.create(
              quantity: 1,
              product_id: @product.id,
              order_id: session[:order_id]
          )
          flash[:success] = "#{@product.name} is added to your cart."
          redirect_to shopping_cart_path
          return
        end
      end
    end

  end

  def retire
    if @product.switch_status
      if @product.active # == true
        flash[:success] = "#{@product.name} is now active and will appear on searches."
        redirect_to manage_tours_path
        return
      else
        flash[:success] = "#{@product.name} is now retired and won't appear on searches."
        redirect_to manage_tours_path
        return
      end
    end
  end

  def explore
    @products = Product.get_top_rated
  end

  # def change_status
  #   if @product.switch_status
  #     flash[:success] = "#{@product.name}'s status is now updated."
  #     redirect_to products_path #merchant dashboard path?
  #     return
  #   end
  # end

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
      render 'products/show', status: :unauthorized
      return
    end
  end

end
