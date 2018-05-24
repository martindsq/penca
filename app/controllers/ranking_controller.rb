class RankingController < ApplicationController
  before_action :authenticate_user!
  def index
    @users = Kaminari.paginate_array(User.sorted_by_points).page(params[:page]).per(10)
  end
end
