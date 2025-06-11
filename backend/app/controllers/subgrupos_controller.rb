class SubgruposController < ApplicationController
  before_action :set_subgrupo, only: %i[ show edit update destroy ]

  # GET /subgrupos or /subgrupos.json
  def index
    @subgrupos = Subgrupo.all
  end

  # GET /subgrupos/1 or /subgrupos/1.json
  def show
  end

  # GET /subgrupos/new
  def new
    @subgrupo = Subgrupo.new
  end

  # GET /subgrupos/1/edit
  def edit
  end

  # POST /subgrupos or /subgrupos.json
  def create
    @subgrupo = Subgrupo.new(subgrupo_params)

    respond_to do |format|
      if @subgrupo.save
        format.html { redirect_to @subgrupo, notice: "Subgrupo was successfully created." }
        format.json { render :show, status: :created, location: @subgrupo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subgrupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subgrupos/1 or /subgrupos/1.json
  def update
    respond_to do |format|
      if @subgrupo.update(subgrupo_params)
        format.html { redirect_to @subgrupo, notice: "Subgrupo was successfully updated." }
        format.json { render :show, status: :ok, location: @subgrupo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subgrupo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subgrupos/1 or /subgrupos/1.json
  def destroy
    @subgrupo.destroy!

    respond_to do |format|
      format.html { redirect_to subgrupos_path, status: :see_other, notice: "Subgrupo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subgrupo
      @subgrupo = Subgrupo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subgrupo_params
      params.expect(subgrupo: [ :name, :precio, :descripcion ])
    end
end
