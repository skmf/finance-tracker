class UserStocksController < ApplicationController
  before_action :set_user_stock, only: [:show, :edit, :update, :destroy]

  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  # GET /user_stocks/1.json
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # GET /user_stocks/1/edit
  def edit
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    
    # stock id is present
    if params[:stock_id].present?
      @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
    
    # stock id is not present (stock is not present in db)
    else
      stock = Stock.find_by_ticker(params[:stock_ticker])
        
        # if stock is valid
        if stock
           @user_stock = UserStock.new(user: current_user, stock: stock)
       
        # stock id not valid
        else
           stock = Stock.new_from_lookup(params[:stock_ticker])
            
            # if stock was found, then save
             if stock.save
                @user_stock = UserStock.new(user: current_user, stock: stock)
             else
                @user_stock = nil
                flash[:error] = "Stock is not available"
             end
        end
    end

    
    # @user_stock = UserStock.new(user_stock_params)

    respond_to do |format|
      if @user_stock.save
        format.html { redirect_to my_portfolio_path, 
        notice: "Stock #{ @user_stock.stock.ticker} stock was successfully added" }
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stocks/1
  # PATCH/PUT /user_stocks/1.json
  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html { redirect_to @user_stock, notice: 'User stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_stock }
      else
        format.html { render :edit }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    # @user_stock.destroy
    @user_stock.destroy(@user_stock[0].id)
    respond_to do |format|
      
      # user_stocks_url
      format.html { redirect_to my_portfolio_path, notice: 'User stock was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stock
      # @user_stock = UserStock.find(params[:id])
      # @user_stock = UserStock.where("stock_id = ? and user_id = ?",params[:id],current_user.id)
      @user_stock = UserStock.where("stock_id = ? and user_id = ?",params[:id],current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_stock_params
      params.require(:user_stock).permit(:user_id, :stock_id)
    end
end
