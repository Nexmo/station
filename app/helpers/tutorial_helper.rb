module TutorialHelper
  def tutorial_subtitle(tutorial)
    products = tutorial[:products].map do |product|
      normalise_product_title(product)
    end

    products.sort.to_sentence
  end

  private

  def normalise_product_title(product)
    return "SMS" if product == 'messaging/sms'
    return "Voice" if product == "voice/voice-api"
    return "Number Insight" if product == "number-insight"
    return product.camelcase
  end
end
