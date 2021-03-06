HasBeen.controllers do
  layout :application

  get :index do
    case username
    when nil
      @travellers = Travellers.find_all
      render "index"
    when "www"
      uri = parsed_uri()
      uri.host = uri.host.sub(/^www./, '')
      redirect uri.to_s
    else
      @traveller = Travellers.find(username)
      halt 404 if @traveller.nil?
      render "location/overview"
    end
  end

  get :index, :map => "/:location" do
    halt 404 unless defined? username
    @traveller = Travellers.find(username)
    halt 404 if @traveller.nil?
    @location = escape_html(params[:location].force_encoding("UTF-8"))
    if @traveller.hasbeen_in?(@location)
      @verb = "has"
    else
      @verb = "hasn't"
      status 404
    end
    render "location/map"
  end

end
