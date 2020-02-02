# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api/V1/Benches', type: :request do
  let!(:greenhouse)    { greenhouses(:greenhouse_1) }
  let!(:greenhouse_id) { greenhouse.id }
  let!(:bench)         { greenhouse.benches.first }
  let!(:id)            { bench.id }

  describe 'GET api/v1/greenhouses/:greenhouse_id/benches' do
    context 'when 200' do
      it_behaves_like 'with authenticated grower' do
        it 'get benches in the given greenhouse with pagination params' do
          get(
            "/api/v1/greenhouses/#{greenhouse_id}/benches",
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

    context 'when 404' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t get benches as a requester' do
          get("/api/v1/greenhouses/#{greenhouse_id}/benches", headers: headers)

          expect(status).to eq(404)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'GET api/v1/benches/:id' do
    context 'when 404' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t get a bench as a requester' do
          get("/api/v1/benches/#{id}", headers: headers)

          expect(status).to eq(404)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'POST api/v1/greenhouses/:greenhouse_id/benches' do
    context 'when 404' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t create a bench as a requester' do
          post("/api/v1/greenhouses/#{greenhouse_id}/benches", headers: headers)

          expect(status).to eq(404)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'PUT api/v1/benches/:id' do
    context 'when 404' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t update a bench as a requester' do
          put("/api/v1/benches/#{id}", headers: headers)

          expect(status).to eq(404)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end

  describe 'DELETE api/v1/benches/:id' do
    context 'when 404' do
      it_behaves_like 'with authenticated requester' do
        it 'can\'t delete a bench as a requester' do
          delete("/api/v1/benches/#{id}", headers: headers)

          expect(status).to eq(404)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end

    context 'when 422' do
      it_behaves_like 'with authenticated grower' do
        it 'fails to delete a bench' do
          allow_any_instance_of(Bench).to receive(:destroy).and_return(false)

          delete("/api/v1/benches/#{id}", headers: headers)

          expect(status).to eq(422)
          expect(JSON.parse(response.body).dig('error', 'message')).not_to be_blank
        end
      end
    end
  end
end
