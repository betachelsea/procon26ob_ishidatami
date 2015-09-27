require "spec_helper"
require "map"
require "pry"

describe Field do
  before do
    @field = Field.new
    @field.setup("00000111111111111111111111111111")
    @field.setup("00000111111111111111111111111111")
    @field.setup("02200111111111111111111111111111")
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

  describe "#settable?" do
    before do
      @stone = double("stone")
      allow(@stone).to receive(:setPosition)
    end

    context "when use first stone(id: 0)" do
      before do
        allow(@stone).to receive(:id).and_return(3)
        allow(@stone).to receive(:map).and_return([
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0],
          [0,0,0,1,0,0,0,0]
        ])
      end
      it "can set on map" do
        expect(@field.settable?(0, 0, @stone)).to be_truthy
      end
      it "can set minus position" do
        expect(@field.settable?(-3, 0, @stone)).to be_truthy
      end
      it "cannot set on map" do
        expect(@field.settable?(-2, 0, @stone)).to be_falsey
      end
    end
  end
end
