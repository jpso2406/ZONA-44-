class IngredientesController < ApplicationController
  before_action :set_ingrediente, only: %i[ show edit update destroy ]

  # GET /ingredientes or /ingredientes.json
  def index
    @ingredientes = Ingrediente.all
  end

  # GET /ingredientes/1 or /ingredientes/1.json
  def show
  end

  # GET /ingredientes/new
  def new
    @ingrediente = Ingrediente.new
  end

  # GET /ingredientes/1/edit
  def edit
  end

  # POST /ingredientes or /ingredientes.json
  def create
    @ingrediente = Ingrediente.new(ingrediente_params)

    respond_to do |format|
      if @ingrediente.save
        format.html { redirect_to @ingrediente, notice: "Ingrediente was successfully created." }
        format.json { render :show, status: :created, location: @ingrediente }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ingrediente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredientes/1 or /ingredientes/1.json
  def update
    respond_to do |format|
      if @ingrediente.update(ingrediente_params)
        format.html { redirect_to @ingrediente, notice: "Ingrediente was successfully updated." }
        format.json { render :show, status: :ok, location: @ingrediente }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ingrediente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredientes/1 or /ingredientes/1.json
  def destroy
    @ingrediente.destroy!

    respond_to do |format|
      format.html { redirect_to ingredientes_path, status: :see_other, notice: "Ingrediente was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingrediente
      @ingrediente = Ingrediente.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def ingrediente_params
      params.expect(ingrediente: [ :nombre ])
    end
end
