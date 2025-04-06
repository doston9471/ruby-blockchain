require 'sinatra'
require 'json'
require 'time'
require 'digest'
require 'dotenv/load'

# Allow test host
configure :test do
  set :allowed_hosts, [ 'example.org' ]
end

# Block class with necessary fields/attributes
class Block
  attr_reader :index, :timestamp, :bpm, :hash, :prev_hash

  def initialize(index, timestamp, bpm, prev_hash)
    @index = index
    @timestamp = timestamp
    @bpm = bpm
    @prev_hash = prev_hash
    @hash = calculate_hash
  end

  def to_h
    {
      index: @index,
      timestamp: @timestamp,
      bpm: @bpm,
      hash: @hash,
      prev_hash: @prev_hash
    }
  end

  def calculate_hash
    record = "#{@index}#{@timestamp}#{@bpm}#{@prev_hash}"
    Digest::SHA256.hexdigest(record)
  end
end

# Global Blockchain & Mutex
BLOCKCHAIN = []
MUTEX = Mutex.new

# Generate Genesis Block
Thread.new do
  genesis_block = Block.new(0, Time.now.to_s, 0, '')
  MUTEX.synchronize { BLOCKCHAIN << genesis_block }
  puts "Genesis Block: #{genesis_block.to_h}"
end

# Routes
set :port, ENV.fetch('PORT', 4567)
set :bind, '0.0.0.0'

get '/' do
  content_type :json
  BLOCKCHAIN.map(&:to_h).to_json
end

post '/' do
  content_type :json
  request_body = request.body.read

  begin
    data = JSON.parse(request_body)
    bpm = data['BPM'] || data['bpm']

    halt 400, { error: 'BPM is required' }.to_json unless bpm

    MUTEX.synchronize do
      prev_block = BLOCKCHAIN.last
      new_block = generate_block(prev_block, bpm.to_i)

      if valid_block?(new_block, prev_block)
        BLOCKCHAIN << new_block
        # puts "New Block: #{new_block.to_h}"
        status 201
        new_block.to_h.to_json
      else
        halt 422, { error: 'Invalid block' }.to_json
      end
    end
  rescue JSON::ParserError
    halt 400, { error: 'Invalid JSON' }.to_json
  end
end

# Helper Methods
def generate_block(prev_block, bpm)
  index = prev_block.index + 1
  timestamp = Time.now.to_s
  Block.new(index, timestamp, bpm, prev_block.hash)
end

def valid_block?(new_block, prev_block)
  return false if new_block.index != prev_block.index + 1

  return false if new_block.prev_hash != prev_block.hash

  return false if new_block.hash != new_block.calculate_hash

  true
end
