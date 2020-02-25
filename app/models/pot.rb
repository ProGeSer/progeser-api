# frozen_string_literal: true

class Pot < ApplicationRecord
  SHAPE_KINDS = %w[square rectangle circle triangle].freeze

  # Enumerize
  extend Enumerize
  enumerize :shape,
            in: SHAPE_KINDS + [:other]

  # Validations
  validates :name,
            :shape,
            presence: true

  validates :area, numericality: { greater_than: 0 }

  # Associations
  has_many :request_distributions,
           class_name: 'RequestDistribution',
           foreign_key: 'pot_id',
           inverse_of: :pot,
           dependent: :destroy
end

# == Schema Information
#
# Table name: pots
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  shape      :string           not null
#  area       :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dimensions :integer          is an Array
#
