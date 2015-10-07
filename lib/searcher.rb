# coding:utf-8
require "./lib/util"
require "./lib/map"

class Searcher
  def initialize(field, stones, filename)
    @init_field = field
    @init_stones = stones
    @filename = filename
    @first_stone_candidates = firstStoneCandidateCheck(field, stones[0])
    @first_stone_candidates.sort! { |a, b| b[:score] <=> a[:score] }
    # TODO: stones[0]が全て空振りだったときのことを検討する
    @answer_count = 0
    @best_score = 32*32
  end

  def work
    @first_stone_candidates.each_with_index do |first, index|
      field = Marshal.load(Marshal.dump(@init_field))
      stones = Marshal.load(Marshal.dump(@init_stones))
      field.setCellStatus(first[:x], first[:y], first[:side], first[:rotate], stones[first[:stone_id]], CellStatus::STONE)
      stones[first[:stone_id]].setStatus(first[:x], first[:y], first[:side], first[:rotate])
      answer_stones = deployStones(field, stones)
      score = field.countEmptyZk
      puts "Export -> No.#{@answer_count}, Score:#{score}, #{"* BEST!" if score < @best_score}"
      @best_score = score if score < @best_score
      exportAnswer(answer_stones)
    @answer_count += 1
    end
  end

  def deployStones(field, stones)
    stones.each do |stone|
      deploy(field, stone) if !stone.deployed
    end
    stones # 定義後
  end

  def firstStoneCandidateCheck(field, stone)
    first_stone_candidates = []
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (0..31).each do |x|
          (0..31).each do |y|
            score = field.getScore(x, y, side, rotate, stone)
            if score != -1
              first_stone_candidates.push({
                x: x, y: y, side: side, rotate: rotate,
                stone_id: stone.id, score: score, last_score: nil})
            end
          end
        end
      end
    end
    first_stone_candidates
  end

  def deploy(field, stone)
    deploy_score = -1
    deploy_x = nil
    deploy_y = nil
    deploy_side = 'H'
    deploy_rotate = 0

    # さがす
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (-7..38).each do |x|
          (-7..38).each do |y|
            new_score = field.getScore(x, y, side, rotate, stone)
            if deploy_score < new_score
              deploy_x = x
              deploy_y = y
              deploy_side = side
              deploy_rotate = rotate
              deploy_score = new_score
            end
          end
        end
      end
    end

    return false if deploy_score == -1
    # デプロイ
    field.setCellStatus(deploy_x, deploy_y, deploy_side, deploy_rotate, stone, CellStatus::STONE)
    stone.setStatus(deploy_x, deploy_y, deploy_side, deploy_rotate)
    # puts "Score: #{deploy_score}, stone.id=#{stone.id}"
    return true
  end

  def exportAnswer(stones)
    File.open(@filename.gsub(/.txt$/, "_answer#{@answer_count}.txt"), "w:ascii-8bit") do |file|
      stones.each do |stone|
        file.print stone.deployed? ? "#{stone.x} #{stone.y} #{stone.side} #{stone.rotate}\r\n" : "\r\n"
      end
    end
  end
end

