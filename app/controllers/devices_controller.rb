class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy, :power, :shutdown]

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def power
    require 'socket'
    sock = TCPSocket.new(@device.ip, 43333)
    sock.write 'SWITCH'+@device.switch.to_s+'=1'
    #puts sock.read(6) # Since the response message has 6 bytes.
    sock.close
    @device.running = DateTime.current() #update Running Since column
    redirect_to '/devices'
  end

  def shutdown
    require 'socket'
    sock = TCPSocket.new(@device.ip, 43333)
    sock.write 'SWITCH'+@device.switch.to_s+'=0' # e.g. SWITCH1=0
    #puts sock.read(6) # Since the response message has 6 bytes.
    sock.close
    @device.running = '' #update Running Since column to null, likely wrong method
    redirect_to '/devices'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:ip, :name, :category, :owner, :description, :switch)
    end
end