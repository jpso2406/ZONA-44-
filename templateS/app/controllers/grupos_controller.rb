class GruposController < ApplicationController
  before_action :set_grupo, only: %i[ show edit update destroy ]

  # GET /grupos or /grupos.json
  def index
    @grupos = Grupo.all
  end

  # GET /grupos/1 or /grupos/1.json
  def show
  end

  # GET /grupos/new
  def new
    @grupo = Grupo.new
  end

  # GET /grupos/1/edit
  def edit
  end

  # POST /grupos or /grupos.json
  def create
    @grupo = Grupo.new(grupo_params)

    respond_to do |format|
      if @grupo.save
        format.html { redirect_to @grupo, notice: "Grupo was successfully created." }
        format.json { render :show, status: :created, location: @grupo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grupos/1 or /grupos/1.json
  def update
    respond_to do |format|
      if @grupo.update(grupo_params)
        format.html { redirect_to @grupo, notice: "Grupo was successfully updated." }
        format.json { render :show, status: :ok, location: @grupo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @grupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grupos/1 or /grupos/1.json
  def destroy
    @grupo.destroy!

    respond_to do |format|
      format.html { redirect_to grupos_path, status: :see_other, notice: "Grupo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_grupo
      @grupo = Grupo.find(params[:id])
    end

    def grupo_params
      params.require(:grupo).permit(:name, :foto)
    end
end
