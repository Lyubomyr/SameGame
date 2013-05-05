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
        @game.update_attribute(:score, 0)
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

def select_group
    id = params[:id]
    ball = params[:ball]
    matrix =  Game.find(id).matrix
    selected = find_group(ball, matrix)

    render :json => selected
  end

  def update_game
    id = params[:id]
    ball = params[:ball]
    game =  Game.find(id)
    matrix = game.matrix
    selected = find_group(ball, matrix)

    update_matrix(selected)
    result = addBalls(game.colors)
    @matrix = result[:matrix]
    l =result[:added].size
    @score = game.score + 2**(l-2)
     game.update_attribute(:matrix, @matrix)
     game.update_attribute(:score, @score)

    # render :json => @matrix
  end

end
