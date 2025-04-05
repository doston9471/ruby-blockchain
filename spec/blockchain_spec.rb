require "rack/test"
require "rspec"
require_relative "../blockchain"

ENV["RACK_ENV"] = "test"
set :allowed_hosts, ['example.org']

RSpec.describe "Blockchain API" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    BLOCKCHAIN.clear
    genesis_block = Block.new(0, Time.now.to_s, 0, '')
    BLOCKCHAIN << genesis_block
  end

  describe "GET /" do
    it "returns the blockchain" do
      get "/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body).to be_an(Array)
      expect(body.first["index"]).to eq(0)
    end
  end

  describe "POST /" do
    context "with valid BPM" do
      it "adds a new block" do
        post "/", { bpm: 80 }.to_json, { "CONTENT_TYPE" => "application/json" }

        expect(last_response.status).to eq(201)
        body = JSON.parse(last_response.body)
        expect(body["index"]).to eq(1)
        expect(body["bpm"]).to eq(80)
        expect(body["prev_hash"]).to eq(BLOCKCHAIN[0].hash)
        expect(BLOCKCHAIN.length).to eq(2)
      end
    end

    context "with invalid JSON" do
      it "returns 400 error" do
        post "/", "not-json", { "CONTENT_TYPE" => "application/json" }
        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to have_key("error")
      end
    end

    context "missing BPM" do
      it "returns 400 error" do
        post "/", {}.to_json, { "CONTENT_TYPE" => "application/json" }
        expect(last_response.status).to eq(400)
        expect(JSON.parse(last_response.body)).to have_key("error")
      end
    end
  end

  describe "block validation" do
    it "rejects invalid block index" do
      invalid_block = Block.new(5, Time.now.to_s, 70, BLOCKCHAIN.last.hash)
      expect(valid_block?(invalid_block, BLOCKCHAIN.last)).to be false
    end

    it "rejects invalid hash chain" do
      block = generate_block(BLOCKCHAIN.last, 72)
      block.instance_variable_set(:@prev_hash, "tampered")
      expect(valid_block?(block, BLOCKCHAIN.last)).to be false
    end

    it "rejects tampered block hash" do
      block = generate_block(BLOCKCHAIN.last, 90)
      block.instance_variable_set(:@hash, "wronghash")
      expect(valid_block?(block, BLOCKCHAIN.last)).to be false
    end
  end
end
