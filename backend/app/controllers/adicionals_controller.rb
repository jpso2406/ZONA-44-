class AdicionalsController < ApplicationController
  before_action :set_adicional, only: %i[ show edit update destroy ]

  # GET /adicionals or /adicionals.json
  def index
    @adicionals = Adicional.all
  end

  # GET /adicionals/1 or /adicionals/1.json
  def show
  end

  # GET /adicionals/new
  def new
    @adicional = Adicional.new
  end

  # GET /adicionals/1/edit
  def edit
  end

  # POST /adicionals or /adicionals.json
  def create
    @adicional = Adicional.new(adicional_params)

    respond_to do |format|
      if @adicional.save
        format.html { redirect_to @adicional, notice: "Adicional was successfully created." }
        format.json { render :show, status: :created, location: @adicional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @adicional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adicionals/1 or /adicionals/1.json
  def update
    respond_to do |format|
      if @adicional.update(adicional_params)
        format.html { redirect_to @adicional, notice: "Adicional was successfully updated." }
        format.json { render :show, status: :ok, location: @adicional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @adicional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adicionals/1 or /adicionals/1.json
  def destroy
    @adicional.destroy!

    respond_to do |format|
      format.html { redirect_to adicionals_path, status: :see_other, notice: "Adicional was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adicional
      @adicional = Adicional.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def adicional_params
      params.expect(adicional: [ :ingredientes ])
    end
end
