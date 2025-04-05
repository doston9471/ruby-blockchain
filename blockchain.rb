require "digest"

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

# Helper Methods
def generate_block(prev_block, bpm)
  index = prev_block.index + 1
  timestamp = Time.now.to_s
  Block.new(index, timestamp, bpm, prev_block.hash)
end
