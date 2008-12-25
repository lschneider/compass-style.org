require 'application'

class Pixelations::StylesheetsController < ApplicationController
  SASS_ENGINE_OPTS = {
    :load_paths => Compass::Frameworks::ALL.map{|f| f.stylesheets_directory}
  }
  layout false

  def new
    @stylesheet = Stylesheet.new
  end

  def create
    @stylesheet = Stylesheet.create(params[:stylesheet])
    redirect_to pixelations_path(:stylesheet => @stylesheet.url_name)
  end

  def show
    @stylesheet = Stylesheet.find_by_url(params[:id])
    if @stylesheet
      respond_to do |wants|
        wants.sass { render :text => @stylesheet.sass }
        wants.css  { render :text => @stylesheet.css  }
      end
    else
      render_error_status(404)
    end
  end

  def compile
    @sass = params[:sass]
    begin
      @css = Sass::Engine.new(@sass, SASS_ENGINE_OPTS).render
      render :text => @css, :layout => false
    rescue Sass::SyntaxError => e
      render :text => e.message, :status => 400, :layout => false
    end
  end

end