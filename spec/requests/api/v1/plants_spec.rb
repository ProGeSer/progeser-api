# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api/V1/Plants', type: :request do
  let!(:plant) { plants(:plant_1) }
  let!(:id) { plant.id }

  describe 'GET api/v1/plants' do
    context 'when 200' do
      it_behaves_like 'with authenticated grower' do
        it 'get plants with pagination params' do
          get(
            '/api/v1/plants',
            headers: headers,
            params: {
              page: {
                number: 1,
                size: 2
              }
            }
          )

          expect(status).to eq(200)

          expect(JSON.parse(response.body).count).to eq(2)
          expect(response.headers.dig('Pagination-Current-Page')).to eq(1)
          expect(response.headers.dig('Pagination-Per')).to eq(2)
          expect(response.headers.dig('Pagination-Total-Pages')).to eq(2)
          expect(response.headers.dig('Pagination-Total-Count')).to eq(3)
        end
      end
    end
  end

  describe 'POST api/v1/plants' do
    context 'when 403' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t create a plant as a requester' do
          post('/api/v1/plants', headers: headers)

          expect(status).to eq(403)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end

    context 'when 422' do
      it_behaves_like 'with authenticated grower' do
        # See comment on validation in app/models/plant.rb
        #
        # it 'fails to create a plant without plant_stage' do
        #   post(
        #     '/api/v1/plants',
        #     headers: headers,
        #     params: {
        #       name: 'foobar'
        #     }
        #   )

        #   expect(status).to eq(422)
        #   expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        # end

        it 'fails to create a plant with missing params' do
          post(
            '/api/v1/plants',
            headers: headers,
            params: {
              name: nil,
              plant_stages_attributes: nil
            }
          )

          expect(status).to eq(422)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'PUT api/v1/plants/:id' do
    context 'when 403' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t udpdate a plant as a requester' do
          put("/api/v1/plants/#{id}", headers: headers)

          expect(status).to eq(403)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end

    context 'when 422' do
      it_behaves_like 'with authenticated grower' do
        # See comment on validation in app/models/plant.rb
        #
        # it 'fails to update a plant when trying to delete all its plant stages' do
        #   put(
        #     "/api/v1/plants/#{id}",
        #     headers: headers,
        #     params: {
        #       name: 'foobar',
        #       plant_stages_attributes: plant.plant_stages.map { |ps| {id: ps.id, _destroy: true } }
        #     }
        #   )

        #   expect(status).to eq(422)
        #   expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        # end

        it 'fails to update a plant with missing params' do
          put(
            "/api/v1/plants/#{id}",
            headers: headers,
            params: {
              name: nil
            }
          )

          expect(status).to eq(422)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'DELETE api/v1/plants/:id' do
    context 'when 403' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t delete a plant as a requester' do
          delete("/api/v1/plants/#{id}", headers: headers)

          expect(status).to eq(403)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end

    context 'when 422' do
      it_behaves_like 'with authenticated grower' do
        it 'fails to delete a plant' do
          allow_any_instance_of(Plant).to receive(:destroy).and_return(false)

          delete("/api/v1/plants/#{id}", headers: headers)

          expect(status).to eq(422)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end
end
