class MyBetsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rows = Match.all.order(time: :asc).map do |match|
      [match, Bet.bet(current_user, match)]
    end
  end

  def save
    flash = {}
    user = current_user
    params[:bets].each do |m, b|
      match = Match.find(m)
      bet = Bet.find_or_initialize_by(match: match, user: user)
      bet.home_score = b[:home_score]
      bet.away_score = b[:away_score]
      if !bet.save()
        flash[match] = bet.errors.full_messages.join(', ')
      end
    end
    redirect_to my_bets_url, :alert => flash 
  end

end
