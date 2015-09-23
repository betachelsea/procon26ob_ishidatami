require "pry"
require "./lib/stone"
require "./lib/map"

stone_manager = nil
readed_storn_count = 0
deploying = 0

field = Field.new

# 読み込み
f = open(ARGV[0])
f.each { |line|
  line.chomp!
  if field.setupFinished?
    field.setup(line)
  elsif 0 < line.length && stone_manager.nil?
    stone_manager = StoneManager.new(line.to_i)
  elsif 0 < line.length
    stone_manager.setStoneState(line)
  end
}
f.close

# 置ける座標におく

def canSetPosition?(x, y, field, stone, deployedMap)
  # puts stone.map
  stone.map.each_with_index do |stone_line, index|
    # puts field[y + index] # 1行
    next if stone_line.count("1") == 0
    search = field.map[y + index][x, 8]
    stone_line.each_char.with_index do |zk, i|
      return false if zk == "1" && search[i] == "1"
    end
  end
  return true
end


def deploy(field, stone, deployedMap)
  # さがす
  (0..31).each do |x|
    (0..31).each do |y|
      if field.settable?(x, y, stone)
        field.setStone(x, y, stone)
        puts "置けます #{x}, #{y}, stone id: #{stone.id}"
        return true
      else
        # puts "置けません！ #{x}, #{y}, stone id: #{stone.id}"
      end
    end
  end
  return false
end

deployedMap = DeployedMap.new


# 解決
stone_manager.stone_collection.each do |stone|
  if deploy(field, stone, deployedMap)
    puts "置けた"
  else
    puts "失敗！"
  end
end

stone_manager.exportAnswer(ARGV[0].gsub(/.txt$/, '_answer.txt'))

