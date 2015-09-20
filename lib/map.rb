# coding:utf-8

class Field
  # 0: 空欄、 1: 置けない場所、 2: 置かれ済みの石
  def initialize
    @map = Array.new(32)
    @field_line_count = 0
    @first_stone_deployed = false
  end

  attr_reader :setup_finished, :map

  def setup(line)
    @map[@field_line_count] = line
    @field_line_count += 1
  end

  def setupFinished?
    @field_line_count + 1 <= 32
  end

  # 問答無用で配置
  def setStone(x, y, stone)
    stone.x = x
    stone.y = y
    stone.map.each_with_index do |stone_line, index|
      map_line = @map[y + index][x, 8]
      merged_line = (map_line.split("").map.with_index do |map_stone, i|
        (stone_line[i] == "1") ? "2" : map_stone
      end).join
      @map[y + index][x, 8] = merged_line
    end
  end

  # 配置可能かチェック
  def settable?(x, y, stone)
    touched_other_stone = false
    stone.map.each_with_index do |stone_line, index|
      next if stone_line.count("1") == 0 # 石が無ければ飛ばす
      return false if @map[y + index].nil? # 石があるのにmap外なら配置不可
      map_line = @map[y + index][x, 8]
      stone_line.each_char.with_index do |zk, i|
        next if zk == "0"
        return false if map_line[i] != "0" # map上にすでに何かあるなら配置不可
        next if touched_other_stone
        next if stone.id.to_i == 0 # 最初の石は以下の処理を無視
        # 辺が既存の石に触れているかを調査
        if (@map[y + index - 1][x + i] == "2" || # 上
            @map[y + index][x + i - 1] == "2" || # 左
            @map[y + index + 1][x + i] == "2" || # 下
            @map[y + index][x + i + 1] == "2")   # 右
          touched_other_stone = true
        end
      end
    end
    return (stone.id.to_i == 0 || touched_other_stone)
  end

end

class DeployedMap
  def initialize()
    @map = Array.new(32) { Array.new(32, "0").join }
  end

  attr_reader :map

  def setStone(stone)
    stone.map.each_with_index do |line, index|
      map_line = @map[stone.y + index][stone.x, 8]
      merged_line = (map_line.split("").map.with_index do |n, i|
        return false if n == "1" && line[i] == "1"
        (line[i] == "1") ? "1" : n
      end).join
      @map[stone.y + index][stone.x, 8] = merged_line
    end
  end
end

