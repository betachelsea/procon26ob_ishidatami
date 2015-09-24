# coding:utf-8

class Searcher
  def deploy(field, stone)
    # さがす
    (-7..31).each do |x|
      (-7..31).each do |y|
        if field.settable?(x, y, stone)
          field.setStone(x, y, stone)
          # 置けるけど接地しているstone数で重み付けしたい
          puts "置けます #{x}, #{y}, stone id: #{stone.id}"
          return true
        else
          # puts "置けません！ #{x}, #{y}, stone id: #{stone.id}"
        end
      end
    end
    return false
  end
end

