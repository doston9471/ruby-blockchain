class Block
  attr_reader :index, :timestamp, :bpm, :hash, :prev_hash

  def initialize(index, timestamp, bpm, prev_hash)
    @index = index
    @timestamp = timestamp
    @bpm = bpm
    @prev_hash = prev_hash
    @hash = calculate_hash #  TODO: calculate_hash method
  end
end