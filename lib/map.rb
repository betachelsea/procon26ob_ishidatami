# coding:utf-8
require "pry"

class Field
  def initialize
    @map = Array.new(32 + 7*2) { Array.new(32 + 7*2) { CellStatus::WALL } }
    @field_line_count = 0
    @first_stone_deployed = false
  end

  attr_reader :setup_finished

  def setup(line)
    @map[@field_line_count + 7][7, line.length] = line.split("").map{|n| n.to_i}
    @field_line_count += 1
  end

  def getMap
    @map[7, 32].map{|line| line[7, 32]}
  end

  def setupFinished?
    @field_line_count + 1 <= 32
  end

  def setCellStatus(x, y, side, rotate, stone, cell_status)
    @first_stone_deployed = true
    stone.getMap(side, rotate).each_with_index do |stone_line, index|
      next if @map[7 + y + index].nil?
      map_line = @map[7 + y + index][7 + x, 8]
      merged_line = map_line.map.with_index do |map_stone, i|
        (stone_line[i] == 1) ? cell_status : map_stone
      end
      @map[7 + y + index][7 + x, 8] = merged_line
    end
  end

  # マップ内のprestoneを変換します
  def prestoneConvert(status)
    @map.map! do |line|
      line.map! { |item| (item == CellStatus::PRESTONE) ? status : item }
    end
  end

  # 孤立セルの調査
  def hasAloneCell?
    (0..32).each do |x|
      (0..32).each do |y|
        next if @map[7 + y][7 + x] != CellStatus::EMPTY
        return true if countNeighborStatus(x, y, CellStatus::EMPTY) == 0
        # 調査する
      end
    end
    return false
  end

  # 配置可能かチェック
  # -1:配置不可, 0〜:配置可、数値は接石数(壁含む)を示す。
  # 0 は実質最初の配置石のみで返される。
  # また、配置の結果、孤立するセルが発生した場合は-1扱いとする。
  def getScore(x, y, side, rotate, stone)
    neighbor_stone_count = 0
    neighbor_wall_count = 0
    stone.getMap(side, rotate).each_with_index do |stone_line, index|
      next if stone_line.count(1) == 0 # 石が無ければ飛ばす
      return -1 if @map[7 + y + index].nil? # 石があるのにmap外なら配置不可
      map_line = @map[7 + y + index][7 + x, 8]
      stone_line.each.with_index do |zk, i|
        next if zk == 0
        return -1 if map_line[i] != 0 # map上にすでに何かあるなら配置不可
        # 辺が既存の石に触れているかを調査
        neighbor_stone_count += countNeighborStone((x + i), (y + index))
        neighbor_wall_count += countNeighborWall((x + i), (y + index))
      end
    end

    return -1 if @first_stone_deployed && neighbor_stone_count == 0
    # 実質配置可
    answer = neighbor_stone_count + neighbor_wall_count
    # 孤立セルのチェック
    setCellStatus(x, y, side, rotate, stone, CellStatus::PRESTONE)
    answer = -1 if self.hasAloneCell?
    setCellStatus(x, y, side, rotate, stone, CellStatus::EMPTY)
    # binding.pry if 30 == stone.id
    return answer
  end

  def countNeighborStatus(x, y, target)
    count = 0
    count += 1 if 0 <= (7 + y - 1) && @map[7 + y - 1][7 + x] == target
    count += 1 if (7 + y + 1) <= 46 && @map[7 + y + 1][7 + x] == target
    count += 1 if 0 <= (7 + x - 1) && @map[7 + y][7 + x - 1] == target
    count += 1 if (7 + x + 1) <= 46 && @map[7 + y][7 + x + 1] == target
    count
  end

  def countNeighborStone(x, y)
    count = 0
    count += 1 if 0 <= (7 + y - 1) && @map[7 + y - 1][7 + x] == 2
    count += 1 if (7 + y + 1) <= 46 && @map[7 + y + 1][7 + x] == 2
    count += 1 if 0 <= (7 + x - 1) && @map[7 + y][7 + x - 1] == 2
    count += 1 if (7 + x + 1) <= 46 && @map[7 + y][7 + x + 1] == 2
    count
  end

  def countNeighborWall(x, y)
    count = 0
    count += 1 if 0 <= (7 + y - 1) && @map[7 + y - 1][7 + x] == 1
    count += 1 if (7 + y + 1) <= 46 && @map[7 + y + 1][7 + x] == 1
    count += 1 if 0 <= (7 + x - 1) && @map[7 + y][7 + x - 1] == 1
    count += 1 if (7 + x + 1) <= 46 && @map[7 + y][7 + x + 1] == 1
    count
  end

end

