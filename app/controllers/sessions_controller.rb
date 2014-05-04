class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json


  # before_filter :authenticate_user!
	@@config = {
    :site => 'https://api.linkedin.com',
    :authorize_path => '/uas/oauth/authenticate',
    :request_token_path => '/uas/oauth/requestToken?scope=r_basicprofile+r_fullprofile+r_emailaddress',
    :access_token_path => '/uas/oauth/accessToken'
  }

  def generate_linkedin_oauth_url
    # if LinkedinOauthSetting.find_by_user_id(current_user.id).nil?
      client = LinkedIn::Client.new('75rv26520ofdeq', 'c7hG6qOpHeBtsKDc', @@config)
      request_token = client.request_token(:oauth_callback => "http://#{request.host}:#{request.port}/oauth_account")
      session[:rtoken] = request_token.token
      session[:rsecret] = request_token.secret
      redirect_to request_token.authorize_url
    # else
    #   redirect_to "/oauth_account"
    # end
  end

  def oauth_account
		client = LinkedIn::Client.new('75rv26520ofdeq', 'c7hG6qOpHeBtsKDc', @@config)
		pin = params[:oauth_verifier]
		if pin
			atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
			LinkedinOauthSetting.create!(:asecret => asecret, :atoken => atoken)
      flash[:notice] = "You logged in with you Linkedin account"
		end
	redirect_to "/"
	end

	def get_client
	  linkedin_oauth_setting = LinkedinOauthSetting.find_by_user_id(current_user.id)
	  client = LinkedIn::Client.new('75rv26520ofdeq', 'c7hG6qOpHeBtsKDc', @@config)
	  client.authorize_from_access(linkedin_oauth_setting.atoken, linkedin_oauth_setting.asecret)
	  client
	end

  def populate_spreadsheet

    consumer_key = 'FwVRzKjwILSAmvFDg1oOlfZNz1hN_5qCSSoG91vv855YK70L2mAcNInKu_bl5wne'
    consumer_secret = '0wLPeVLQ18EcYE_kYTIepA94L7iAaywMJbv4W_MhJn3EgI9QexB5Ro2k1DhFF1H6'



    # testing with fetched access keys
    # rtoken = '8e25a084-abb3-45fa-ac18-8d13fda3045c'
    # rsecret = "891aa8eb-2ffb-4c79-b15f-6a69d48893e7"

    rtoken = '3351e4af-1c51-4d53-9bb2-b7e73d562754'
    rsecret = 'ddc2af99-6c18-4c6f-9a8f-1770d67f36dc'

    # client = LinkedIn::Client.new('75rv26520ofdeq', 'c7hG6qOpHeBtsKDc', @@config)

    client = LinkedIn::Client.new(consumer_key, consumer_secret)
    request_token = client.request_token({}, :scope => "r_basicprofile r_emailaddress")
    client.authorize_from_access(rtoken, rsecret)

    # login
    session = GoogleDrive.login("ifyouseesomethingmta@gmail.com", "mtasux1983")
    # the url provided by the user
    url =  params[:url]
    # url = 'https://docs.google.com/spreadsheets/d/1q3CvCXwPzyxZCKgqVzJKe9LuyjSQj6f6F6wEIs9hYKU/edit#gid=2066141450'
    # extract out the id
    ssid = url.match(/d\/(.+?)\/edit/m).captures[0]

    ws = session.spreadsheet_by_key(ssid).worksheets[0]

    # loop through each of the names here
    for row in 2..ws.num_rows
      fname = ws[row, 1]
      lname = ws[row, 2]

      # is there a company name
      if ws[row,3].to_s != ''
        company = ws[row,3]
      end

      # get the first result for this name
      id = client.search(:first_name => fname, :last_name => lname, :sort => 'relevance').people.all.first.id

      profile = client.profile(:id => id, :fields => %w(first-name,last-name,email-address,positions,distance,headline,industry,summary,specialties,phone-numbers,twitter-accounts,picture-url,member-url-resources,public-profile-url,relation-to-viewer:(num-related-connections,related-connections),site-standard-profile-request:(url)))

      # company
      ws[row, 3] = profile.positions.all.first.company.name
      # profile pic
      ws[row, 4] = "=image(\"#{profile.picture_url}\", 1)"
      ws.save()

      break if row == 3
      render json: {}
    end

  end



end
