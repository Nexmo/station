class MarkdownController < ApplicationController
  def show
    render text: "Product: #{params[:product]} | Document: #{params[:document]}"
  end
end
