# frozen_string_literal: true

class Bench < ApplicationRecord
  # Enumerize
  extend Enumerize
  enumerize :shape,
            in: Pot.shape.values

  # Validations
  validates :shape, presence: true

  validates :area, numericality: { greater_than: 0 }

  # Associations
  belongs_to :greenhouse,
             class_name: 'Greenhouse',
             foreign_key: 'greenhouse_id',
             inverse_of: :benches

  has_many :request_distributions,
           class_name: 'RequestDistribution',
           foreign_key: 'bench_id',
           inverse_of: :bench,
           dependent: :restrict_with_error
end

# == Schema Information
#
# Table name: benches
#
#  id            :bigint           not null, primary key
#  greenhouse_id :bigint
#  name          :string
#  shape         :string           not null
#  area          :decimal(, )      not null
#  dimensions    :integer          is an Array
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_benches_on_greenhouse_id  (greenhouse_id)
#
