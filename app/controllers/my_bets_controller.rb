class MyBetsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @stage = params[:stage] ? Stage.includes(matches: [:stadium, :home_team, :away_team, :stage]).find(params[:stage]) : nil
    matches = @stage&.matches || Match.includes(:stadium, :home_team, :away_team, :stage).all
    @rows = matches.order(time: :asc).map do |match|
      [match, Bet.bet(current_user, match)]
    end
  end

  def save
    alert = {}
    user = current_user
    params[:bets].each do |m, b|
      match = Match.find(m)
      bet = Bet.find_or_initialize_by(match: match, user: user)
      bet.home_score = b[:home_score]
      bet.away_score = b[:away_score]
      bet.winning_team_id = b[:winning_team]
      if !bet.save()
        alert[match.to_s] = bet.errors.full_messages.first
      end
    end
    if alert.blank?
      redirect_to request.url, :notice => t('my_bets.index.save_success_notice')
    else
      redirect_to request.url, :alert => alert
    end
  end

end
