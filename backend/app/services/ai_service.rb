# app/services/ai_service.rb
require "openai"

class AiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["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"])
  end

  def analizar_ventas
    datos = Pedido.group(:producto).count
    prompt = "Analiza estas ventas y dime cuál producto tiene más demanda: #{datos}"

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }]
      }
    )

    response.dig("choices", 0, "message", "content")
  end
end
