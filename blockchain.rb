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