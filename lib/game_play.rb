module GamePlay

    def rnd(colors)
       random = Random.new
       random.rand(0..colors)
    end

    def generate_matrix(game)
          matrix = []

          game.height.times  do |row_i|
                row = []
                game.width.times{|col| row[col] = rnd(game.colors-1)}
                matrix[row_i] = row
          end
          return matrix
    end

    def find_group(ball, matrix)
        @matrix = matrix
        @selected = [{row: ball[:row], col: ball[:col], color: ball[:color]}]
        @sel_index = 0

        find_neighbors(ball)
        return @selected
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
          # debugger
          return nil unless (@matrix[n_row].present?) && (n_row >= 0) && (n_col >=0)
          (@selected.include?(ball) == false) && (@matrix[n_row][n_col] == color) ? ball : nil
    end

    def update_matrix(selected)
        shift = {}
        selected.each do |ball|
            @matrix[ball[:row]][ball[:col]] = nil
             shift.has_key?(ball[:col]) ? shift[ball[:col]] += 1 : shift[ball[:col]] = 1
        end
        # @matrix.map {|row| row.compact!}
        shift_matrix(shift)
    end

    def shift_matrix(shift)
        shift.each_key do |col_i|
            @matrix.each_index do |row_i|
                  unless @matrix[row_i][col_i]
                      normalize_column(col_i, row_i, shift[col_i])
                  end
            end
        end
    end

    def normalize_column(col_i, nil_i, size)
        size.times do |nils|
            nil_i.times do |i|
                @matrix[nil_i-1-i+nils][col_i], @matrix[nil_i-i+nils][col_i]=@matrix[nil_i-i+nils][col_i],@matrix[nil_i-1-i+nils][col_i]
            end
        end
    end

    def addBalls(colors)
      added = []
      @matrix.each_index do |row_i|
          row = @matrix[row_i]
          row.each_index do |col_i|
              col = row[col_i]
              unless @matrix[row_i][col_i]
                  color = rnd(colors-1)
                  added.push({row: row_i, col: col_i, color: color})
                  @matrix[row_i][col_i] = color
              end
          end
      end
          return {matrix: @matrix, added: added}
    end
end

