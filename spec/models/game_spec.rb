# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  user       :string(255)
#  width      :integer
#  height     :integer
#  colors     :integer
#  score      :integer
#  matrix     :text
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
