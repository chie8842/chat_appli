class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :update, :destroy]
  before_action :confirm_session

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all.order("created_at DESC")
    @tweet = Tweet.new
    @hashtags = Hashtag.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    hashTag = Hashtag.find_by(id: params[:id])
    if hashTag == nil || hashTag.tweets.empty?
      session[:hashtag] = nil
      redirect_to tweets_path, method: 'get'
      return
    else
      session[:hashtag] = params[:id]
      @tweets = hashTag.tweets(true).order("created_at DESC")
      @tweets.reverse
      @tweet = Tweet.new
      @hashtags = Hashtag.all
      render :index
    end
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    
    tweet = Tweet.new(params.require(:tweet).permit(:tweet))
    #tweet.user = User.find(session[:user_id]).name
    tweet.userId = session[:user_id]
    tweet.userName = session[:user_name]
    
    str = tweet.tweet
    hashTagName = nil
    str.each_line {|line|
      hashTagName = line
    }
    if /^#/ =~ hashTagName
      exitTag = Hashtag.find_by(name: hashTagName)
      if exitTag == nil
        hashtag = Hashtag.new
        hashtag.name = hashTagName
        tweet.hashtags << hashtag
        hashtag.save
      else
        tweet.hashtags << exitTag
      end
    end
    
    tweet.save
    #render :index
    if !session[:hashtag]
      redirect_to tweets_path, method: 'get'
    else
      redirect_to tweet_path(session[:hashtag]), method: 'get'
    end
    
    
    #@tweet = Tweet.new(tweet_params)

    #respond_to do |format|
    #  if @tweet.save
    #    format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
    #    format.json { render :show, status: :created, location: @tweet }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @tweet.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    if @tweet.userId.to_i == session[:user_id].to_i
      @tweet.destroy
    end
    respond_to do |format|
      format.html { redirect_to tweet_path(session[:hashtag]), notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:user, :tweet)
    end
    
    def confirm_session
      if !session[:user_id]
        redirect_to login_path, method: 'delete'
      end
    end
end
