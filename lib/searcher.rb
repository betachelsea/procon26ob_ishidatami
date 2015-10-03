# coding:utf-8
require "./lib/util"

class Searcher
  def deploy(field, stone)
    deploy_score = -1
    deploy_x = nil
    deploy_y = nil
    deploy_side = 'H'
    deploy_rotate = 0

    # さがす
    ['H', 'T'].each do |side|
      [0, 90, 180, 270].each do |rotate|
        (-7..31).each do |x|
          (-7..31).each do |y|
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

