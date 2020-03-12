require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  # Setups
  def setup
    @request = requests(:request_1)
  end

  # Validations
  test 'valid request' do
    assert @request.valid?, @request.errors.messages
  end

  test 'valid without handler' do
    @request.handler = nil
    assert @request.valid?, @request.errors.messages
  end

  test 'valid without plant_stage and a non-accepted status' do
    @request.plant_stage = nil
    @request.status = :pending
    assert @request.valid?, @request.errors.messages
  end

  test 'valid without comment' do
    @request.comment = nil
    assert @request.valid?, @request.errors.messages
  end

  test 'valid without temperature' do
    @request.temperature = nil
    assert @request.valid?, @request.errors.messages
  end

  test 'valid without photoperiod' do
    @request.photoperiod = nil
    assert @request.valid?, @request.errors.messages
  end

  test 'invalid without author' do
    @request.author = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:author]
  end

  test 'invalid without name' do
    @request.name = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:name]
  end

  test 'invalid without status' do
    @request.status = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:status]
  end

  test 'invalid without due_date' do
    @request.due_date = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:due_date]
  end

  test 'invalid without quantity' do
    @request.quantity = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:quantity]
  end

  test 'invalid without plant_name' do
    @request.plant_name = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:plant_name]
  end

  test 'invalid without plant_stage_name' do
    @request.plant_stage_name = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:plant_stage_name]
  end

  # Enumerize
  test 'invalid with incorrect status value' do
    @request.status = 'foo'
    assert_not @request.valid?
    assert_not_empty @request.errors[:status]
  end

  # State Machine
  test 'can\'t be accepted without at least one request distribution' do
    @request.request_distributions = []
    assert_not @request.valid?
    assert_not_empty @request.errors[:request_distributions]
  end

  test 'can\'t be accepted without a plant stage' do
    @request.plant_stage = nil
    assert_not @request.valid?
    assert_not_empty @request.errors[:plant_stage]
  end
end

# == Schema Information
#
# Table name: requests
#
#  id               :bigint           not null, primary key
#  author_id        :bigint
#  handler_id       :bigint
#  plant_stage_id   :bigint
#  name             :string
#  plant_name       :string
#  plant_stage_name :string
#  status           :string
#  comment          :text
#  due_date         :date
#  quantity         :integer
#  temperature      :integer
#  photoperiod      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_requests_on_author_id       (author_id)
#  index_requests_on_handler_id      (handler_id)
#  index_requests_on_plant_stage_id  (plant_stage_id)
#
