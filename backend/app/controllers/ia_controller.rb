class IaController < ApplicationController

  def consultar
    # Obtener los productos de la base de datos
    productos = Producto.all.map { |p| { nombre: p.name, precio: p.precio, descripcion: p.descripcion } }

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    prompt = <<~PROMPT
      Eres un asistente experto en análisis de productos de comida rápida.
      A continuación tienes una lista de productos disponibles en la base de datos:
      #{productos.to_json}

      Basándote en esta información, responde a la siguiente pregunta del usuario:
      "#{params[:pregunta]}"
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "Eres un asistente útil y experto en análisis de productos gastronómicos." },
          { role: "user", content: prompt }
        ]
      }
    )

    @respuesta_ia = response.dig("choices", 0, "message", "content")
    Rails.logger.info "Respuesta IA: #{@respuesta_ia.inspect}"
    if @respuesta_ia.blank?
      @respuesta_ia = "No se pudo obtener una respuesta de la IA. Por favor, intenta nuevamente o revisa la configuración de la API."
    end
    render :reporte
  end
end
