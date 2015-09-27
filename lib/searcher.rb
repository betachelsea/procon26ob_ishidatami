# coding:utf-8

class Searcher
  def deploy(field, stone)
    deploy_score = -1
    deploy_x = nil
    deploy_y = nil
    # さがす
    (-7..31).each do |x|
      (-7..31).each do |y|
        new_score = field.getScore(x, y, stone)
        if deploy_score < new_score
          deploy_x = x
          deploy_y = y
          deploy_score = new_score
        end
      end
    end

    return false if deploy_score == -1
    # デプロイ
    field.setStone(deploy_x, deploy_y, stone)
    puts "Score: #{deploy_score}"
    return true
  end
end

