class AddressesController < ApplicationController
  # GET /addresses/new
  def new
    @address = Address.new
  end

  # POST /addresses
  def create
    addr = params.dig(:address, :addr)
    # STEP_1 check verification code
    @address = Address.new(address_params)
    unless verify_rucaptcha?
      flash.now[:captcha] = "captcha is wrong"
      return render :new
    end

    # STEP_2 check address info
    unless TransactionInterface.is_address(addr)
      # address is error
      flash.now[:addr] = "address is wrong"
      return render :new
    end

    # STEP_3 save address
    @address.save

    # STEP_4 send a transaction to chain
    @transaction_interface = TransactionInterface.new
    _hash, _state = TransactionInterface.transfer(addr)

    # STEP_5 notify frontend
    flash[:success] = "send success"
    redirect_to new_address_path
  end

  private

  def address_params
    # patch_params
    params.require(:address).permit(:addr)
  end

end
