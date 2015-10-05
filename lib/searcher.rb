# coding:utf-8
require "./lib/util"
require "./lib/map"

class Searcher
  def initialize(field, stones)
    @init_field = field
    @init_stones = stones
  end

  def deployStones
    field = @init_field.clone
    stones = @init_stones.clone
    stones.each do |stone|
      if deploy(field, stone)
        puts "置けた"
      else
        puts "失敗！"
      end
    end
    stones # 定義後
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
    puts "Score: #{deploy_score}, stone.id=#{stone.id}"
    return true
  end
end

