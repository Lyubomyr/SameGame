module GamePlay

    def rnd(colors)
       random = Random.new
       random.rand(0..colors)
    end

    def generate_matrix(game)
          matrix = []

          game.width.times  do |col_i|
                col = []
                game.height.times{|row| col[row] = rnd(game.colors-1)}
                matrix[col_i] = col
          end
          return matrix
    end

    def find_group(ball, matrix)
        @matrix = matrix
        @selected = [{row: ball[:row], col: ball[:col], color: ball[:color]}]
        @sel_index = 0

        find_neighbors(ball)
        @selected.size > 1 ? (return @selected) : nil
    end

    def find_neighbors(ball)
          row = ball[:row]
          col = ball[:col]
          color = ball[:color]

          @selected.push(is_same_color(row-1, col, color))
          @selected.push(is_same_color(row, col+1, color))
          @selected.push(is_same_color(row+1, col, color))
          @selected.push(is_same_color(row, col-1, color))
          @selected.compact!

          @sel_index = @sel_index + 1
          find_neighbors(@selected[@sel_index])  if (@sel_index < @selected.length)
    end

    def is_same_color(n_row, n_col, color)
          ball = {row: n_row, col: n_col, color: color}
          return nil unless (@matrix[n_col].present?) && (n_row >= 0) && (n_col >=0)
          (@selected.include?(ball) == false) && (@matrix[n_col][n_row] == color) ? ball : nil
    end

    def update_matrix(selected)
        shift = {} # {col: deleted_balls} == {1: 2, 5: 1}
        selected.each do |ball|
            @matrix[ball[:col]][ball[:row]] = nil
             shift.has_key?(ball[:col]) ? shift[ball[:col]] += 1 : shift[ball[:col]] = 1
        end
        shift_matrix(shift)
        return shift
    end

    def shift_matrix(shift)
        shift.each_key do |col_i|
            @matrix[col_i].compact!
              shift[col_i].times do
                  @matrix[col_i].unshift(nil)
              end
        end
    end

    def addBalls(colors)
      added = []
      @matrix.each_index do |col_i|
          @matrix[col_i].each_index do |row_i|
              unless @matrix[col_i][row_i]
                  color = rnd(colors-1)
                  added.push({row: row_i, col: col_i, color: color})
                  @matrix[col_i][row_i] = color
              end
          end
      end
          added = added.sort_by { |ball| ball[:row] }
          return added.reverse!
    end

        def update_db(game, added)
            score = game.score + 2**(added.size-2)
            game.update_attribute(:matrix, @matrix)
            game.update_attribute(:score, score)
            return score
        end
end

