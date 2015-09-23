require "spec_helper"
require "stone"

describe Stone do
  before do
    @stone = Stone.new(0)
  end

  describe "#setState" do
    before do
      @stone.setState("10010000")
    end
    it { expect(@stone.map[0]).to match_array([1,0,0,1,0,0,0,0,]) }
  end

end
