class SessionsController < ApplicationController
  def create
    @response =
    Faraday.post("https://github.com/login/oauth/access_token?client_id=7760a1816e44b0fe9b1a&client_secret=3f38122420de9482b196a4a46da84dccdb8200cc&code=#{params["code"]}")
    token = @response.body.split(/\W+/)[1]
    oauth_response = Faraday.get("https://api.github.com/user?access_token=#{token}")
    auth = JSON.parse(oauth_response.body)

    user = User.find_or_create_by(uid: auth["id"])
    user.username = auth["login"]
    user.uid = auth["id"]
    user.token = token
    user.save

    session[:user_id] = user.id
    redirect_to dashboard_index_path
  end
end
