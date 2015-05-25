class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:show, :notAvailable, :find, :check]
  helper_method :sort_column, :sort_direction

  def check
    @client = Client.new
  end

  # GET /tests
  # GET /tests.json
  def index
    params[:result] ||= " "
    params[:CT] ||= " "
    params[:NG] ||= " "
    @tests = Test.search(params[:search]).filter(params[:CT], params[:NG], params[:result]).order(sort_column + " " + sort_direction).page(params[:page])
    @download = Test.search(params[:search]).filter(params[:CT], params[:NG], params[:result]).order(sort_column + " " + sort_direction)

    @file = TestResultFile.new
    
    respond_to do |format|
      format.html
      format.xls
    end
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    @testResult = Test.find(params[:id])
  end

  def find
    id = params[:number]
    @testResult = Test.find_by(:testId => id)
    if @testResult
      if @testResult.result == "Positive"
        redirect_to alert_test_path(id)
      else
        redirect_to @testResult
      end
    else
      redirect_to notAvailable_test_path(id)
    end
  end

  def notAvailable
    @id = params[:id]
    @client = Client.new
  end
  
  def alert
    @id = params[:id]
  end

  # GET /tests/new
  def new
    @test = Test.new
  end

  # GET /tests/1/edit
  def edit
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)

    respond_to do |format|
      if @test.save
        format.html { redirect_to @test, notice: 'Test was successfully created.' }
        format.json { render :show, status: :created, location: @test }
      else
        format.html { render :new }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if @test.update(test_params)
        format.html { redirect_to @test, notice: 'Test was successfully updated.' }
        format.json { render :show, status: :ok, location: @test }
      else
        format.html { render :edit }
        format.json { render json: @test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    respond_to do |format|
      format.html { redirect_to tests_url, notice: 'Test was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test
      @test = Test.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_params
      params.require(:test).permit(:result, :testId, :CT, :NG, :start_at, :end_at)
    end

    def sort_column
      Test.column_names.include?(params[:sort]) ? params[:sort] : "end_at"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
