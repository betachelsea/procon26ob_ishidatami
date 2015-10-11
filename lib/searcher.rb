# coding:utf-8
require 'fileutils'
require "./lib/util"
require "./lib/field"

class Searcher
  def initialize(field, stones, filename)
    @init_field = field
    @init_stones = stones
    @filename = filename
    @answer_count = 0
    @best_score = 32*32
    @best_score_stone_count = 256
    @trial_count = 0
  end

  def work
    field = Marshal.load(Marshal.dump(@init_field))
    stones = Marshal.load(Marshal.dump(@init_stones))
    repeatDeployStones(field, stones, 0)
  end

  def repeatDeployStones(field, stones, check_stone_id)
    stone = stones[check_stone_id]

    if stone.nil?
      # 終了検知
      @trial_count += 1
      score = field.countEmptyZk
      deployed_stone_count = stones.count {|stone| stone.deployed? }
      #スコアが上がったら回答を出力
      if (score < @best_score) || (score == @best_score && deployed_stone_count < @best_score_stone_count)
        puts "\nExport -> No.#{@answer_count}, Score:#{score}, stone:#{deployed_stone_count} NOW BEST!"
        exportAnswer(stones)
        @best_score = score
        @best_score_stone_count = deployed_stone_count
        @answer_count += 1
      else
        print "\r Skip Answer *************** -> score:#{score}, trial_count:#{@trial_count}****************"
      end
      return true
    end

    candidates = getCandidatesArray(field, stone)
    # 再帰的にトライ
    candidates.each do |status|
      field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::STONE)
      stone.setStatus(status[:x], status[:y], status[:side], status[:rotate])
      if check_stone_id + 1 <= stones.count
        repeatDeployStones(field, stones, check_stone_id + 1)
        field.setCellStatus(status[:x], status[:y], status[:side], status[:rotate], stone, CellStatus::EMPTY)
        stone.reset
      end
    end
    repeatDeployStones(field, stones, check_stone_id + 1) # 何もせずに次を試す
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

  def exportAnswer(stones)
    org_filename = @filename.match(/\/(.+).txt$/)[1]
    filepath = "resource/answer#{org_filename}/#{org_filename}_answer_#{@answer_count}.txt"
    dirname = File.dirname(filepath)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    File.open(filepath, "w:ascii-8bit") do |file|
      stones.each do |stone|
        file.print stone.deployed? ? "#{stone.x} #{stone.y} #{stone.side} #{stone.rotate}\r\n" : "\r\n"
      end
    end
  end
end

