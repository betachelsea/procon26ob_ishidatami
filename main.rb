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

