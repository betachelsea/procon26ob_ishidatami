# coding:utf-8

class StoneManager
  def initialize(n)
    @stone_collection = Array.new(n) { |n| Stone.new(n) }
    @initialized_count = 0
  end

  attr_reader :stone_collection

  def setStoneState(line)
    target = @stone_collection[@initialized_count]
    target.setState(line)
    if target.setup_finished?
      @initialized_count = @initialized_count + 1
    end
  end

  def getStone(id)
    @stone_collection[id]
  end

  def stoneCount
    @stone_collection.count
  end

  def exportAnswer
    File.open("answer.txt", "w:ascii-8bit") do |file|
      @stone_collection.each do |stone|
        file.print stone.deployed? ? "#{stone.x} #{stone.y} H 0\r\n" : "\r\n"
      end
    end
  end
end

class Stone
  def initialize(id)
    @id = id
    @x = nil
    @y = nil
    @map = Array.new()
  end

  attr_accessor :x, :y
  attr_reader :id
  attr_reader :map

  def setState(line)
    @map << line if !line.empty?
  end

  def setup_finished?
    8 <= @map.length
  end

  def deployed?
    !@x.nil? || !@y.nil?
  end
end
