class RankingController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = User.invitation_accepted.limit(30).sort{|a,b| a.points <=> b.points}
  end
end
