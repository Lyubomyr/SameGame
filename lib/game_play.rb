module GamePlay

    def generate_matrix(game)
          matrix = []
          rnd = Random.new
          game.height.times  do |row_i|
                row = []
                game.width.times{|col| row[col] = rnd.rand(3..game.colors)}
                matrix[row_i] = row
          end
          return matrix
    end

end