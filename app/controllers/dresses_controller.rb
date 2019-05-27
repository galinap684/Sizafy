class DressesController < ApplicationController
  before_action :set_dress, only: [:show, :edit, :update, :destroy]

  def index
    #  @dresses = dress.all

    @collections = current_user.collections


      @user = current_user
    #  conn = PG.connect(dbname: 'galinapodstrechnaya', user: 'galinapodstrechnaya')
    #  @dresses = conn.exec("select * from dresses")


      if @user[:waist] < 26 && @user[:bust] < 33 && @user[:hips] < 37
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{XXS}'::text[];")
        @user.revolve = "XXS"
        @user.save
      end

      if @user[:waist] > 24 && @user[:waist] < 27 && @user[:bust] > 31 && @user[:bust] < 34 && @user[:hips] > 35 && @user[:hips] < 38
        # size 4 on asos
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{XS}'::text[];");
        @user.revolve = "XS"
        @user.save
      end

      if @user[:waist] > 25 && @user[:waist] < 28 && @user[:bust] > 33 && @user[:bust] < 36 && @user[:hips] > 36 && @user[:hips] < 39
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{S}'::text[];");
        @user.revolve = "S"
        @user.save
      end


      if @user[:waist] > 27 && @user[:waist] < 30 && @user[:bust] > 34 && @user[:bust] < 37 && @user[:hips] > 38 && @user[:hips] < 41
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{M}'::text[];");
        @user.revolve = "M"
        @user.save
      end

      if @user[:waist] > 28 && @user[:waist] < 31 && @user[:bust] > 35 && @user[:bust] < 38 && @user[:hips] > 39 && @user[:hips] < 42
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{L}'::text[];");
        @user.revolve = "L"
        @user.save
      end

      if @user[:waist] > 29 && @user[:waist] > 32 && @user[:bust] > 36 && @user[:bust] < 39  && @user[:hips] > 40 && @user[:hips] < 43
        @dresses = execute_statement("SELECT * FROM dresses WHERE size && '{XL}'::text[];");
        @user.revolve = "XL"
        @user.save
      end
    end

  # GET /dresses/1
  # GET /dresses/1.json
  def show
    @dress = Dress.find(params[:id])
      @collections = current_user.collections

      @collections_dress = CollectionsDress.new(col_params)

  end

  # GET /dresses/new
  def new
    @dress = Dress.new
    @collections_dress = Collections_dress.new
  end

  # GET /dresses/1/edit
  def edit
  end

  # POST /dresses
  # POST /dresses.json
  def create
    #@dress = Dress.new(dress_params)
    @user = current_user
#  @collection = Collection.new(collection_params)
  #@collections_dress = @collection.dresses.create(params[:dress])
  @collections_dress = CollectionsDress.create(col_params)
  @dress.collections_dresses <<  @collections_dress
=begin  respond_to do |format|
      if @dress.save
        format.html { redirect_to @dress, notice: 'Dress was successfully created.' }
        format.json { render :show, status: :created, location: @dress }
      else
        format.html { render :new }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
=end
respond_to do |format|
  if @collections_dress.save
   format.html { redirect_to '/collections_dresses', notice: 'The item was successfully added.' }
   format.json { render :show, status: :created, location: 'collections_dresses' }
  else
    format.html { render :new }
    format.json { render json: @collection.errors, status: :unprocessable_entity }
  end
end


  end


  # PATCH/PUT /dresses/1
  # PATCH/PUT /dresses/1.json
  def update
    respond_to do |format|
      if @dress.update(dress_params)
        format.html { redirect_to @dress, notice: 'Dress was successfully updated.' }
        format.json { render :show, status: :ok, location: @dress }
      else
        format.html { render :edit }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dresses/1
  # DELETE /dresses/1.json
  def destroy
    @dress.destroy
    respond_to do |format|
      format.html { redirect_to dresses_url, notice: 'Dress was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dress
      @dress = Dress.find(params[:id])
    end

    def col_params
      params.permit(:collection_id, :dress_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dress_params
      params.fetch(:dress, {})
    end
end
