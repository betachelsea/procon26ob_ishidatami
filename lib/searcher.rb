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

  def repeatDeployStones(field, stones, check_stone_id)
    stone = stones[check_stone_id]
    candidates = getCandidatesArray(field, stone)
    # 再帰的にトライ
    candidates.each do |status|
      field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::PRESTONE)
      if field.hasAloneCell?
        field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::EMPTY)
      else
        field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::STONE)
        stone.setStatus(status[:x], status[:y], status[:side], status[:rotate])
        if stones.count <= check_stone_id + 1
          repeatDeployStones(field, stones, check_stone_id + 1)
        else
          # 終了検知
          score = field.countEmptyZk
          puts "Export -> No.#{@answer_count}, Score:#{score}, #{"* BEST!" if score < @best_score}"
          @best_score = score if score < @best_score
          exportAnswer(answer_stones)
          @answer_count += 1
        end
      end
    end
  end

  def getCandidatesArray(field, stone)
    candidates = []
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (-7..(31+7)).each do |x|
          (-7..(31+7)).each do |y|
            score = field.getScore(x, y, side, rotate, stone)
            if score != -1
              candidates.push({
                x: x, y: y, side: side, rotate: rotate,
                stone_id: stone.id, score: score, last_score: nil})
            end
          end
        end
      end
    end
    candidates.sort! { |a, b| b[:score] <=> a[:score] }
  end

  def firstStoneCandidateCheck(field, stone)
    first_stone_candidates = []
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (-7..(31+7)).each do |x|
          (-7..(31+7)).each do |y|
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
    stone_candidates = []

    # さがす
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (-7..38).each do |x|
          (-7..38).each do |y|
            new_score = field.getScore(x, y, side, rotate, stone)
            if 0 < new_score
              stone_candidates.push({
                x: x, y: y, side: side, rotate: rotate,
                stone_id: stone.id, score: new_score })
            end
          end
        end
      end
    end

    # 配置候補の中からベストなものを探す
    deployed = false
    stone_candidates.sort! { |a, b| b[:score] <=> a[:score] }
    stone_candidates.each do |status|
      field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::PRESTONE)
      if field.hasAloneCell?
        field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::EMPTY)
      else
        deployed = true
        field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::STONE)
        stone.setStatus(status[:x], status[:y], status[:side], status[:rotate])
        break
      end
    end

    return deployed
  end

  def exportAnswer(stones)
    File.open(@filename.gsub(/.txt$/, "_answer#{@answer_count}.txt"), "w:ascii-8bit") do |file|
      stones.each do |stone|
        file.print stone.deployed? ? "#{stone.x} #{stone.y} #{stone.side} #{stone.rotate}\r\n" : "\r\n"
      end
    end
  end
end

