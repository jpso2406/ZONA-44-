
class IaController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def consultar
    # Obtener los productos de la base de datos

    # Mejorar la presentación de los productos con emojis y formato
    productos = Producto.all.map do |p|
      grupo = p.grupo&.nombre || "Sin grupo"
      precio = p.precio.to_i
      emoji = case grupo.downcase
        when /hamburguesa/ then "🍔"
        when /perro/ then "🌭"
        when /salchipapa/ then "🍟"
        when /bebida/ then "🥤"
        when /asado/ then "🥩"
        when /sandwich/ then "🥪"
        when /gourmet/ then "🍽️"
        when /desgranado/ then "🌽"
        when /picada/ then "🍢"
        when /infantil/ then "🧒"
        else "🍽️"
      end
      "#{emoji} #{p.name} (#{grupo})\n   💲#{precio} - #{p.descripcion}"
    end

    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    prompt = <<~PROMPT
      Eres un asistente experto en análisis de productos de comida rápida.
      A continuación tienes una lista de productos disponibles en la base de datos:
      #{productos.to_json}

      Basándote en esta información, responde a la siguiente pregunta del usuario:
      "#{params[:pregunta]}"
    PROMPT

    begin
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
    rescue Faraday::TooManyRequestsError
      @respuesta_ia = "El asistente virtual está recibiendo muchas consultas en este momento. Por favor, intenta de nuevo en unos minutos. 🙏🤖"
    rescue => e
      @respuesta_ia = "Ocurrió un error inesperado al consultar la IA. Intenta más tarde."
      Rails.logger.error "Error IA: #{e.class} - #{e.message}"
    end
    render :reporte
  end
end
