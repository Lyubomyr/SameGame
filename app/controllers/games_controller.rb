class GamesController < ApplicationController
  include GamePlay

  def index
    @games = Game.all
  end

  def show
    @game = Game.find_by_user(params[:id])
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
    matrix =  Game.find_by_user(id).matrix
    selected = find_group(ball, matrix)

    render :json => selected
  end

  def update_game
        id = params[:id]
        ball = params[:ball]
        game =  Game.find_by_user(id)
        matrix = game.matrix
        selected = find_group(ball, matrix)

        if selected
            deleted = update_matrix(selected)
            added = addBalls(game.colors)
            score = update_db(game, added)

            render :json => {selected: selected, deleted: deleted, added: added, score: score}
        else
            render :json => {selected: nil}
        end
  end

end
