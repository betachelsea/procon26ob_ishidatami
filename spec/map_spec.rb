require "spec_helper"
require "util"
require "map"
require "stone"
require "pry"

describe Field do
  before do
    @field = Field.new
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 5
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 10
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 15
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 20
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 25
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111") # 30
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")

    @field2 = Field.new
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11101111111111111111111111111111")
    @field2.setup("11100111111111111111111111111111")
    @field2.setup("11110111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111") # 5
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111110000111111111111111111111") # 10
    @field2.setup("11111110000111111111111111111111")
    @field2.setup("11111110000111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111011111111111111") # 15
    @field2.setup("11111111111111111000011111111111")
    @field2.setup("11111111111111111111001111111111")
    @field2.setup("11111111111111111100011111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111") # 20
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111") # 25
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111") # 30
    @field2.setup("11111111111111111111111111111111")
    @field2.setup("11111111111111111111111111111111")
  end

  describe "#setup" do
    it { expect(@field.getMap[0]).to match_array(
          [0,0,0,0,0, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1]) }
  end

  describe "#setCellStatus" do
    before do
      @stone = Stone.new(0)
      @stone.setState("00000000")
      @stone.setState("10000000")
      @stone.setState("00000000")
      @stone.setState("00000000")
      @stone.setState("00000000")
      @stone.setState("00000000")
      @stone.setState("00000000")
      @stone.setState("00000000")
      @field.setCellStatus(0, 0, 'H', 0, @stone, CellStatus::STONE)
      @stone.setStatus(0, 0, 'H', 0)

      @stone2 = Stone.new(1)
      @stone2.setState("00000000")
      @stone2.setState("01100000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @field.setCellStatus(0, 0, 'H', 0, @stone2, CellStatus::PRESTONE)
      @stone2.setStatus(0, 0, 'H', 0)
    end
    it { expect(@field.getMap[1][0]).to eq(CellStatus::STONE) } # @field.getMap[y][x]
    it { expect(@field.getMap[1][1]).to eq(CellStatus::PRESTONE) }
  end

  describe "#getScore" do
    before do
      @stone1 = Stone.new(0)
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")

      @stone2 = Stone.new(1)
      @stone2.setState("00000000")
      @stone2.setState("00011000")
      @stone2.setState("00001000")
      @stone2.setState("00011000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
    end

    context "when set first stone" do
      it { expect(@field.getScore(-7, 0, 'H', 0, @stone1)).to eq(-1) }  # 領域外なので不可
      it { expect(@field.getScore(-2, 1, 'H', 0, @stone1)).to eq(0) }   # 隣接ゼロだが配置可
      it { expect(@field.getScore(-3, 1, 'H', 0, @stone1)).to eq(8) }   # 隣接数：8
    end

    context "when set second stone" do
      before do
        @field.setCellStatus(-2, 1, 'H', 0, @stone1, CellStatus::STONE)
        @stone1.setStatus(-2, 1, 'H', 0)
        map = @field.getMap
      end
      it { expect(@field.getScore(-3, 25, 'H', 0, @stone2)).to eq(-1) } # 隣接していないので配置不可
      it { expect(@field.getScore(-1, 1, 'T', 0, @stone2)).to eq(3) }   # 隣接数：3
      # it { expect(@field.getScore(-1, 1, 'H', 0, @stone2)).to eq(-1) }   # 設置の結果、孤立セルが発生するので配置不可

      it "no change map" do
        map = Marshal.load(Marshal.dump(@field.getMap))
        @field.getScore(-1, 1, 'H', 0, @stone2)
        expect(map).to eq(@field.getMap)
      end
    end

  end

  describe "#hasAloneCell?" do
    before do
      @stone1 = Stone.new(0)
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")
      @stone1.setState("00010000")

      @stone2 = Stone.new(1)
      @stone2.setState("00000000")
      @stone2.setState("00011000")
      @stone2.setState("00001000")
      @stone2.setState("00011000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
      @stone2.setState("00000000")
    end

    context "when have alone cell" do
      before do
        @field.setCellStatus(-2, 1, 'H', 0, @stone1, CellStatus::STONE)
        @field.setCellStatus(-1, 1, 'H', 0, @stone2, CellStatus::PRESTONE)
      end

      it { expect(@field.hasAloneCell?).to be_truthy }
    end
  end

  describe "#countEmptyZk" do
    it { expect(@field.countEmptyZk).to eq(160) }
    it { expect(@field2.countEmptyZk).to eq(26) }
  end

  describe "#countEmptyField" do
    it { expect(@field.countEmptyField).to eq(1) }
    it { expect(@field2.countEmptyField).to eq(3) }
  end

  describe "#findIsland" do
    it { expect(@field2.findIsland(-7, -7, [])).to eq([]) }
    it { expect(@field2.findIsland(3, 1, []).count).to eq(4) }
    it { expect(@field2.findIsland(7, 10, []).count).to eq(12) }
  end

  describe "#getCellId" do
    it { expect(@field.getCellId(-7, -7)).to eq(0) }
    it { expect(@field.getCellId(0, 0)).to eq(329) }
  end

end

