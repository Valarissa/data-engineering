require 'text_importer'

class TextImporterController < ApplicationController
  # GET /import
  def new
    @import_results = TextImporter.new
  end

  # POST /import
  # POST /import.json
  def create
    @import_results = TextImporter.new.import_from_file(file.open)

    respond_to do |format|
      if @import_results
        format.html { redirect_to imported_purchases_url(@import_results.purchases.first, @import_results.purchases.last), notice: 'Purchases successfully imported.' }
        format.json { render action: 'show', status: :created, location: @import_results.total }
      else
        format.html { render action: 'new' }
        format.json { render json: @import_result.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  private

  def file
    params[:file]
  end
end
