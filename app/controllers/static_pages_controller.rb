class StaticPagesController < ApplicationController

  def home
    if signed_in?
      @task  = current_user.tasks.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
