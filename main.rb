require "pry"
require "./lib/stone"
require "./lib/map"
require "./lib/searcher"

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
    stone_manager = StoneReader.new(line.to_i)
  elsif 0 < line.length
    stone_manager.setStoneState(line)
  end
}
f.close

searcher = Searcher.new(field)

# 解決
stones = stone_manager.stone_collection
stones = searcher.deployStones(stones)

stone_manager.exportAnswer(stones, ARGV[0].gsub(/.txt$/, '_answer.txt'))

