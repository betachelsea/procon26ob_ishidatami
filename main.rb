require "pry"
require "./lib/stone"
require "./lib/map"
require "./lib/searcher"

stone_manager = nil
readed_storn_count = 0
deploying = 0

field = Field.new
searcher = Searcher.new

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

# 解決
stone_manager.stone_collection.each do |stone|
  if searcher.deploy(field, stone)
    puts "置けた"
  else
    puts "失敗！"
  end
end

stone_manager.exportAnswer(ARGV[0].gsub(/.txt$/, '_answer.txt'))

