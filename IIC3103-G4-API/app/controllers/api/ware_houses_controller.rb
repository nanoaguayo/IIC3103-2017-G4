class Api::WareHousesController < Api::ApplicationController
  before_action :set_ware_house, only: [:show, :update, :destroy]

  # GET /ware_houses
  # GET /ware_houses.json
  def index
    @ware_houses = WareHouse.all
  end

  # GET /ware_houses/1
  # GET /ware_houses/1.json
  def show
  end

  def skus_with_stock
    @ware_house = WareHouse.find(params[:almacenId])
    @products = Product.where(ware_house_id: @ware_house.id)
    if @products then
      render :show_products
    else
      render_error('Invalid ware house id')
    end

  end

  def moveStock
    @product = Product.find(params[:productoId])
    @ware_house_old = WareHouse.find(@product.ware_house_id)
    @ware_house = WareHouse.find(params[:almacenId])
    if @product and @ware_house then
      if @ware_house.usedspace + 1 > @ware_house.totalspace then
        render_error('Not enough space on warehouse')
      else
        @product.update(ware_house_params)
        render :show_products
      end
    else
      render_error('Product or Warehouse not found')
    end
  end

  def stock
    @ware_house = WareHouse.find(params[:almacenId])
    @products = Product.where(ware_house_id: @ware_house.id)
    if @products then
      render :show_products
    else
      render_error('Invalid ware house id')
    end

  end

  # POST /ware_houses
  # POST /ware_houses.json
  def create
    @ware_house = WareHouse.new(ware_house_params)

    if @ware_house.save
      render :show, status: :created, location: @ware_house
    else
      render json: @ware_house.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ware_houses/1
  # PATCH/PUT /ware_houses/1.json
  def update
    if @ware_house.update(ware_house_params)
      render :show, status: :ok, location: @ware_house
    else
      render json: @ware_house.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ware_houses/1
  # DELETE /ware_houses/1.json
  def destroy
    @ware_house.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ware_house
      @ware_house = WareHouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ware_house_params
      params.require(:ware_house).permit(:usedspace, :totalspace, :reception, :dispatch, :pulmon)
    end
end
