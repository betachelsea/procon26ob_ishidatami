# coding:utf-8

class StoneReader
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
end

class Stone
  def initialize(id)
    @id = id
    @x = nil
    @y = nil
    @side = 'H' # 'H' or 'T'
    @rotate = 0 # 0, 90, 180, 270 のいずれか
    @init_map = Array.new()
    @status = {}
    @deployed = false #配置済み
  end

  attr_reader :x, :y, :side, :rotate
  attr_reader :id
  attr_reader :deployed

  def getMap(side=@side, rotate=@rotate)
    @status["#{side}#{rotate}"]
  end

  def generateStoneStatus
    # 8種類作って保持
    @status["H0"]   = @init_map
    @status["H90"]  = @init_map.transpose.map(&:reverse)
    @status["H180"] = @status["H90"].transpose.map(&:reverse)
    @status["H270"] = @status["H180"].transpose.map(&:reverse)
    @status["T0"]   = @init_map.map(&:reverse)
    @status["T90"]  = @status["T0"].transpose.map(&:reverse)
    @status["T180"] = @status["T90"].transpose.map(&:reverse)
    @status["T270"] = @status["T180"].transpose.map(&:reverse)
  end

  def setState(line)
    @init_map << line.split("").map{|n| n.to_i} if !line.empty?
    self.generateStoneStatus if self.setup_finished?
  end

  def setStatus(x, y, side, rotate)
    @x = x
    @y = y
    @side = side
    @rotate = rotate
    @deployed = true
  end

  def setup_finished?
    8 <= @init_map.length
  end

  def deployed?
    !@x.nil? || !@y.nil?
  end
end
