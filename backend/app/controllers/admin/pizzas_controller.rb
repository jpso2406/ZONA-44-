class Admin::PizzasController < AdminController
  before_action :set_pizza, only: [:edit, :update, :destroy]
  before_action :set_grupos, only: [:new, :create, :edit, :update]

  def new
    @pizza = Pizza.new
    @pizza.tamano_pizzas.build([
      { tamano: 'personal', tamano_cm: 20 },
      { tamano: 'small', tamano_cm: 30 },
      { tamano: 'medium', tamano_cm: 40 },
      { tamano: 'large', tamano_cm: 50 }
    ])
    render partial: 'form'
  end

  def create
    @pizza = Pizza.new(pizza_params)
    @pizza.categoria ||= 'tradicional' # Valor por defecto
    
    if @pizza.save
      render json: { 
        success: true, 
        message: 'Pizza creada exitosamente',
        html: render_to_string(partial: 'admin/pizza_card', locals: { pizza: @pizza })
      }
    else
      render json: { success: false, errors: @pizza.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render partial: 'form'
  end

  def update
    if @pizza.update(pizza_params)
      render json: {
        success: true,
        message: 'Pizza actualizada exitosamente',
        html: render_to_string(partial: 'admin/pizza_card', locals: { pizza: @pizza })
      }
    else
      render json: { success: false, errors: @pizza.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @pizza.destroy
    render json: { success: true, message: 'Pizza eliminada exitosamente' }
  end

  private

  def set_pizza
    @pizza = Pizza.find(params[:id])
  end

  def set_grupos
    @grupos = Grupo.all
  end

  def pizza_params
    params.require(:pizza).permit(
      :nombre, 
      :descripcion, 
      :categoria,
      :grupo_id,
      :foto,
      :borde_queso,
      :combinada,
      tamano_pizzas_attributes: [:id, :tamano, :tamano_cm, :precio, :_destroy]
    )
  end
end
