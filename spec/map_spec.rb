require "spec_helper"
require "map"
require "pry"

describe Field do
  before do
    @field = Field.new
  end
  describe "#setup" do
    before do
      @field.setup("00000111111111111111111111111111")
    end
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
      @field.setup("02200111111111111111111111111111")
      @stone = double("stone")
      allow(@stone).to receive(:setPosition)
    end

    context "when use first stone(id: 0)" do
      before do
        allow(@stone).to receive(:id).and_return(3)
      end
      it "can set on map" do
        allow(@stone).to receive(:map).and_return([[0,0,0,1,0,0,0,0]])
        expect(@field.settable?(0, 0, @stone)).to be_truthy
      end
      it "can set minus position" do
        allow(@stone).to receive(:map).and_return(
          [[0,0,0,0,0,0,0,0],
           [0,0,0,0,0,0,0,1]])
        expect(@field.settable?(-7, -1, @stone)).to be_truthy
      end
      it "cannot set on map" do
        allow(@stone).to receive(:map).and_return([[0,0,0,0,0,1,0,0]])
        expect(@field.settable?(0, 0, @stone)).to be_falsey
      end
    end
  end
end
