class LoginsController < ApplicationController
  def show
      render "login"
  end

  def create
    user = User.find_by_name params[:name]
    if user && user.authenticate(params[:pass])
      # セッションのキー:user_idへユーザーのIDを登録
      session[:user_id] = user.id
      session[:user_name] = user.name
      redirect_to tweets_path
    else
      # flash変数にメッセージをセット
      flash.now.alert = "もう一度入力してください。"
      render "login"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    @current_user = nil
    redirect_to login_path
  end
end