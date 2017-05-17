class Api::WareHousesController < Api::ApplicationController

  def fabricar
    cantidad = params[:cantidad].to_i
    sku = params[:sku]
    if cantidad <= 5000 then
      body = {
        'sku': sku,
        'cantidad': Integer(cantidad)
      }
      resp = Fetcher.Bodegas("PUT"+sku.to_s+cantidad.to_s,"fabrica/fabricarSinPago",body)
      render json: resp
    else
      #Dont send
      render_error("Maximum quantity allowed is 5000")
    end
  end
  #update local stock
  def updateStock
    products = Product.all
    almacenes = Fetcher.Bodegas("GET","almacenes")
    newStock = Hash.new 0
    for alm in almacenes do
      stock = Fetcher.Bodegas("GET"+alm['_id'],"skusWithStock?almacenId="+alm['_id'])
      for aux in stock do
        newStock[aux['_id']] = newStock[aux['_id']] + aux['total']
      end
    end
    for key in newStock.keys do
      prodAux = Product.where(sku:key).first
      prodAux.stock = newStock[key]
      prodAux.save
    end
  end

  def testMovement
    fabricar(20,120)
    #moveStock(55,'590baa76d6b4ec00049028af')
  end


  def cleanPulmon
      #TODO
      almacenes = Fetcher.Bodegas("GET","almacenes")
      for alm in almacenes do
        if alm['pulmon'] && alm['usedSpace'] > 0 then
          #Move to dispatch storage

        end
      end
  end

  #TODO check if working
  def moveStock(id,to)
    #to = almacenId
    body = {
      'productoId': id,
      'almacenId': to
    }
    resp = Fetcher.Bodegas("POST"+id.to_s+to.to_s,"moveStock",body)
    render json: resp
  end

  def dispatchStock(prodId,oc,address,price)
    body = {
      'productoId': prodId,
      'oc': oc,
      'direccion': address,
      'precio': price
    }
    resp = Fetcher.Bodegas("DELETE"+prodId.to_s+address.to_s+price.to_s+oc.to_s,"stock",)
    render json:resp
  end



  #TODO CHECK IF USEFUL OR DELETE
  #ANTIGUO
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

  def moveStock2
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
