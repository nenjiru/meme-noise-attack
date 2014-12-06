class BaseController < ApplicationController
  protect_from_forgery with: :exception

  def hoge
    render :text => 'hoge'
  end

  def redirect
    redirect_to tweets_path
  end
end
