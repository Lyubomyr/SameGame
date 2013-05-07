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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Game < ActiveRecord::Base
  attr_accessible :colors, :height, :width, :user
  serialize :matrix

  extend FriendlyId
  friendly_id :user, use: :slugged

  validates :user, presence: true, :uniqueness => true
  validates :width, presence: true, :inclusion => { :in => 5..20, :message => "of the game field must be between 5 and 20"}, :numericality => { :only_integer => true }
  validates :height, presence: true, :inclusion => { :in => 5..20, :message => "of the game field must be between 5 and 20" }, :numericality => { :only_integer => true }
  validates :colors, presence: true, :inclusion => { :in => 3..10, :message => "used in game must be between 3 and 10" }, :numericality => { :only_integer => true }
end
