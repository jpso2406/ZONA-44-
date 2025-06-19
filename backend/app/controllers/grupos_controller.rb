class GruposController < ApplicationController
  before_action :set_grupo, only: %i[ show edit update destroy ]

  # GET /grupos or /grupos.json
  def index
    @grupos = Grupo.all
  end

  # GET /grupos/1 or /grupos/1.json
  def show
    @grupo = Grupo.find(params[:id])
  end

  # GET /grupos/new
  def new
    @grupo = Grupo.new
    respond_to do |format|
      format.html { render :new, layout: false }
      format.json { render json: @grupo }
    end
  end

  # GET /grupos/1/edit
  def edit
    @grupo = Grupo.find(params[:id])
    render partial: 'form', locals: { grupo: @grupo }, layout: false
  end


  # POST /grupos or /grupos.json
  def create
    @grupo = Grupo.new(grupo_params)

    respond_to do |format|
      if @grupo.save
        format.html do
          render partial: "admin/grupo_card", locals: { grupo: @grupo }, status: :created
        end
        format.json { render :show, status: :created, location: @grupo }
      else
        format.html do
          render partial: "grupos/form", locals: { grupo: @grupo }, status: :unprocessable_entity
        end
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
    logger.debug "Entrando al método destroy con ID: #{params[:id]}"
    @grupo.destroy!

    respond_to do |format|
      format.html { redirect_to grupos_path, status: :see_other, notice: "Grupo eliminado con éxito." }
      format.json { head :no_content }
    end
  end

  private

    def set_grupo
      @grupo = Grupo.find(params[:id])
    end

    def grupo_params
      params.require(:grupo).permit(:nombre, :foto)
    end
end
