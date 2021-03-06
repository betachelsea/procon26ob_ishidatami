require "spec_helper"
require "stone"

describe Stone do
  before do
    @stone = Stone.new(0)
    @stone.setState("00000000")
    @stone.setState("11000000")
    @stone.setState("11110000")
    @stone.setState("00111100")
    @stone.setState("00001100")
    @stone.setState("00000000")
    @stone.setState("00000000")
    @stone.setState("00000000")
  end

  describe "#setState" do
    it { expect(@stone.getMap[1]).to match_array([1,1,0,0,0,0,0,0,]) }
  end

  describe "#getMap" do
    it { expect(@stone.getMap('H', 0)).to match_array([
        [0,0,0,0,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [1,1,1,1,0,0,0,0],
        [0,0,1,1,1,1,0,0],
        [0,0,0,0,1,1,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('H', 90)).to match_array([
        [0,0,0,0,0,1,1,0],
        [0,0,0,0,0,1,1,0],
        [0,0,0,0,1,1,0,0],
        [0,0,0,0,1,1,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('H', 180)).to match_array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,1,1,1,1,0,0],
        [0,0,0,0,1,1,1,1],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('H', 270)).to match_array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,1,1,0,0,0,0,0],
        [0,1,1,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('T', 0)).to match_array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,1],
        [0,0,0,0,1,1,1,1],
        [0,0,1,1,1,1,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('T', 90)).to match_array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,0,1,1,0,0],
        [0,0,0,0,1,1,0,0],
        [0,0,0,0,0,1,1,0],
        [0,0,0,0,0,1,1,0],
      ]) }

    it { expect(@stone.getMap('T', 180)).to match_array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,1,1,0,0],
        [0,0,1,1,1,1,0,0],
        [1,1,1,1,0,0,0,0],
        [1,1,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
      ]) }

    it { expect(@stone.getMap('T', 270)).to match_array([
        [0,1,1,0,0,0,0,0],
        [0,1,1,0,0,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,1,1,0,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
      ]) }
  end

end
