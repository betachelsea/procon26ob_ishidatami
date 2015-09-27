require "spec_helper"
require "map"
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
  end

  describe "#setup" do
    it { expect(@field.getMap[0]).to match_array(
          [0,0,0,0,0, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1]) }
  end

  describe "#setStone" do
    before do
      @stone = double("stone")
      allow(@stone).to receive(:setPosition)
    end
    it "success set stone" do
      allow(@stone).to receive(:map).and_return([[0,1,0,0,0,0,0,0]])
      @field.setStone(0, 0, @stone)
      expect(@field.getMap[0][1]).to eq(2)
    end
  end

  describe "#getScore" do
    before do
      @stone1 = double("stone")
      allow(@stone1).to receive(:setPosition)
      allow(@stone1).to receive(:id).and_return(3)
      allow(@stone1).to receive(:map).and_return([
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,1,0,0,0,0]
      ])

      @stone2 = double("stone")
      allow(@stone2).to receive(:setPosition)
      allow(@stone2).to receive(:id).and_return(4)
      allow(@stone2).to receive(:map).and_return([
        [0,0,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,1,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
      ])
    end

    context "when set first stone" do
      it { expect(@field.getScore(-7, 0, @stone1)).to eq(-1) }  # 領域外なので不可
      it { expect(@field.getScore(-2, 1, @stone1)).to eq(0) }   # 隣接ゼロだが配置可
      it { expect(@field.getScore(-3, 1, @stone1)).to eq(8) }   # 隣接数：8
    end

    context "when set second stone" do
      before do
        @field.setStone(-2, 1, @stone1)
      end
      it { expect(@field.getScore(-3, 25, @stone2)).to eq(-1) } # 隣接していないので配置不可
      it { expect(@field.getScore(-1, 1, @stone2)).to eq(4) }   # 隣接数：4
    end
  end
end
