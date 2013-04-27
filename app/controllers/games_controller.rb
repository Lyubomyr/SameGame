class GamesController < ApplicationController
  include GamePlay

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
    @matrix = @game.matrix
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

      if @game.save
        matrix = generate_matrix @game
        @game.update_attribute(:matrix, matrix)
        redirect_to @game, notice: 'Lets Play'
      else
        render action: "new"
     end
  end

  def restore_game
      user = params[:user]
      @game = Game.find_by_user(user)
      if @game
          redirect_to @game, notice: "Game Restored"
      else
          redirect_to new_game_path , alert: "No user found"
      end
  end
end
