class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :professional_params, only: [:create]
  before_action :configure_sign_up_params, only: [:create, :update]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    #@client=Client.new
    #@client.telephones.build
    super

  end


  # POST /resource
  def create

    build_resource(sign_up_params)
    resource.save

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        #respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end

      #debugger
      if professional_params[:is_profesional]=='1'
        @professional=Professional.new
        @professional.description=professional_params[:description]
        @professional.client=resource
        @professional.save!
        #redirect_to edit_professional_path(@professional)
        redirect_to @professional
      else
        redirect_to new_event_path
      end

    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def professional_params
    params.require(:client).permit(professional: [:description, :is_profesional])[:professional]
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:attribute, :login, :name, :cpf,
                                             [telephones_attributes: [:telephone]],
                                             :professional,
                                             :additional])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute, :login, :name, :cpf,
                                                              [telephones_attributes: [:telephone]],
                                                              [professional: [:description]],
                                                              :additional])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def after_sign_in_path_for(resource_or_scope)
    # products_path
    #'/welcome/filter'
    new_event_path
  end
end
