# coding:utf-8
require "pry"

class Field
  def initialize
    @map = Array.new(32 + 7*2) { Array.new(32 + 7*2) { CellStatus::VIRTUAL_WALL } }
    @stone_id_map = Array.new(32 + 7*2) { Array.new(32 + 7*2) { CellStatus::VIRTUAL_WALL } }
    @field_line_count = 0
    @first_stone_deployed = false
  end

  attr_reader :setup_finished
  attr_reader :first_stone_deployed

  def countEmptyZk
    @map.flatten.count(CellStatus::EMPTY)
  end

  # フィールド内で空の領域を探索する
  # mapのidは x + y * (32 + 7*2)
  # 現在、空のひとつなぎの領域が何個あるかチェックして返す
  def countEmptyField
    @emptyFieldIds = [] # 1つが望ましい
    @count = 0

    # 1セルずつ見る
    # 白にぶちあたったら @emptyFieldsとして登録して次へ
    (0..32).each do |y|
      (0..32).each do |x|
        next if @map[y + 7][x + 7] != CellStatus::EMPTY
        next if @emptyFieldIds.any? { |id| id == getCellId(x, y) }
        island = findIsland(x, y, [])
        next if island.count == 0
        @emptyFieldIds.concat(island)
        @count += 1
      end
    end

    @count
  end

  # フィールド内で空の領域を探索する
  # mapのidは x + y * (32 + 7*2)
  # return [3, 9, 6] # からの領域ぶんの数値の配列が返される
  def getEmptyFieldInfo
    emptyFieldIds = [] # チェック済みの空zkのid配列
    results = []

    # 1セルずつ見る
    # 白にぶちあたったら @emptyFieldsとして登録して次へ
    (0..32).each do |y|
      (0..32).each do |x|
        next if @map[y + 7][x + 7] != CellStatus::EMPTY
        next if emptyFieldIds.any? { |id| id == getCellId(x, y) }
        island = findIsland(x, y, [])
        next if island.count == 0
        emptyFieldIds.concat(island)
        results.push(island.count)
      end
    end

    return results
  end

  ## 空の領域に接している配置石で一番若いIDを取ってくる
  def getUndoStoneId
    # 1セルずつ見る
    result_stone_ids = []
    (0..32).each do |y|
      (0..32).each do |x|
        next if @stone_id_map[y + 7][x + 7] != CellStatus::EMPTY
        # up
        if 0 <= (7 + y - 1) && CellStatus::ID_MAP_BASE <= @stone_id_map[y + 7 - 1][x + 7]
          result_stone_ids.push(@stone_id_map[y + 7 - 1][x + 7])
        end

        # down
        if (7 + y + 1) <= 46 && CellStatus::ID_MAP_BASE <= @stone_id_map[y + 7 + 1][x + 7]
          result_stone_ids.push(@stone_id_map[y + 7 + 1][x + 7])
        end

        # left
        if 0 <= (7 + x - 1) && CellStatus::ID_MAP_BASE <= @stone_id_map[y + 7][x + 7 - 1]
          result_stone_ids.push(@stone_id_map[y + 7][x + 7 - 1])
        end

        # right
        if (7 + x + 1) <= 46 && CellStatus::ID_MAP_BASE <= @stone_id_map[y + 7][x + 7 + 1]
          result_stone_ids.push(@stone_id_map[y + 7][x + 7 + 1])
        end
      end
    end

    return (result_stone_ids.min - CellStatus::ID_MAP_BASE)
  end

  def findIsland(x, y, foundIds)
    cell_id = getCellId(x, y)
    map_x = x + 7
    map_y = y + 7
    return foundIds if foundIds.any? { |id| id == cell_id}
    return foundIds if @map[map_y][map_x] != CellStatus::EMPTY
    foundIds.push(cell_id)

    # 上下左右
    foundIds = findIsland(x, y - 1, foundIds)
    foundIds = findIsland(x, y + 1, foundIds)
    foundIds = findIsland(x - 1, y, foundIds)
    foundIds = findIsland(x + 1, y, foundIds)

    return foundIds
  end

  def getCellId(x, y) # 0 < x,y < 32
    ((y + 7) * (32 + 7*2)) + (x + 7)
  end

  def setup(line)
    @map[@field_line_count + 7][7, line.length] = line.split("").map{|n| n.to_i}
    @stone_id_map[@field_line_count + 7][7, line.length] = line.split("").map{|n| n.to_i}
    @field_line_count += 1
  end

  def getMap
    @map[7, 32].map{|line| line[7, 32]}
  end

  def getStoneIdMap
    @stone_id_map[7, 32].map{|line| line[7, 32]}
  end

  def setupFinished?
    @field_line_count + 1 <= 32
  end

  def setCellStatus(x, y, side, rotate, stone, cell_status)
    @first_stone_deployed = true if cell_status == CellStatus::STONE
    stone.getMap(side, rotate).each_with_index do |stone_line, index|
      next if @map[7 + y + index].nil?
      map_line = @map[7 + y + index][7 + x, 8]
      merged_line = map_line.map.with_index do |map_stone, i|
        (stone_line[i] == 1) ? cell_status : map_stone
      end
      @map[7 + y + index][7 + x, 8] = merged_line

      # こちらも更新
      id_map_line = @stone_id_map[7 + y + index][7 + x, 8]
      id_merged_line = id_map_line.map.with_index do |id_map_stone, i|
        if (stone_line[i] == 1)
          if cell_status == CellStatus::STONE
            stone.id + CellStatus::ID_MAP_BASE
          else
            CellStatus::EMPTY
          end
        else
          id_map_stone
        end
      end
      @stone_id_map[7 + y + index][7 + x, 8] = id_merged_line
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
    neighbor_virtual_wall_count = 0
    stone.getMap(side, rotate).each_with_index do |stone_line, index|
      next if stone_line.count(1) == 0 # 石が無ければ飛ばす
      return -1 if @map[7 + y + index].nil? # 石があるのにmap外なら配置不可
      map_line = @map[7 + y + index][7 + x, 8]
      stone_line.each.with_index do |zk, i|
        next if zk == 0
        return -1 if map_line[i] != CellStatus::EMPTY # map上にすでに何かあるなら配置不可
        # 辺が既存の石に触れているかを調査
        neighbor_stone_count += countNeighborStatus((x + i), (y + index), CellStatus::STONE)
        neighbor_wall_count += countNeighborStatus((x + i), (y + index), CellStatus::WALL)
        neighbor_virtual_wall_count += countNeighborStatus((x + i), (y + index), CellStatus::VIRTUAL_WALL)
      end
    end

    return -1 if @first_stone_deployed && neighbor_stone_count == 0
    # 実質配置可
    return neighbor_stone_count + (neighbor_wall_count * 2) + neighbor_virtual_wall_count
  end

  def countNeighborStatus(x, y, target)
    count = 0
    count += 1 if 0 <= (7 + y - 1) && @map[7 + y - 1][7 + x] == target
    count += 1 if (7 + y + 1) <= 46 && @map[7 + y + 1][7 + x] == target
    count += 1 if 0 <= (7 + x - 1) && @map[7 + y][7 + x - 1] == target
    count += 1 if (7 + x + 1) <= 46 && @map[7 + y][7 + x + 1] == target
    count
  end

end

