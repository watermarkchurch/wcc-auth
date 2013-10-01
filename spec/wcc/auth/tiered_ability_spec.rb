require 'spec_helper'

describe WCC::Auth::TieredAbility do
  let(:klass) { WCC::Auth::TieredAbility }
  let(:access_level) { WCC::Auth::AccessLevel }

  describe "defining levels" do
    it "stores blocks in ::levels" do
      subclass = Class.new(klass) do
        at_level(:basic) {}
        at_level(:contribute) {}
        at_level(:basic) {}
      end
      expect(subclass.levels[access_level[:basic]].size).to eq(2)
      expect(subclass.levels[access_level[:contribute]].size).to eq(1)
    end
  end

  describe "#initialize" do
    it "grants access to the user's access_level" do
      ability = Class.new(klass) do
        at_level(:basic) { |user| user.ping }
      end
      user = double("User")
      level = double("AccessLevel")
      allow(level).to receive(:>=).and_return(true)
      expect(user).to receive(:access_level).and_return(level)
      expect(user).to receive(:ping)
      ability.new(user)
    end
  end

  describe "#grant_access_at" do
    let(:mock_klass) {
      Class.new(klass) do
        def initialize(mock)
          @user = mock
        end
      end
    }

    it "runs only the levels that the given access level allows" do
      ability = Class.new(mock_klass) do
        at_level(:basic) { |mock| mock.basic }
        at_level(:appadmin) { |mock| mock.appadmin }
      end
      mock = double
      expect(mock).to receive(:basic)
      ability.new(mock).grant_access_at(access_level[:manage])
    end

    it "runs the blocks in the defined order" do
      ability = Class.new(mock_klass) do
        at_level(:appadmin) { |mock| mock.first }
        at_level(:basic) { |mock| mock.second }
        at_level(:manage) { |mock| mock.fourth }
        at_level(:basic) { |mock| mock.third }
      end
      mock = double
      expect(mock).to receive(:first).ordered
      expect(mock).to receive(:second).ordered
      expect(mock).to receive(:third).ordered
      expect(mock).to receive(:fourth).ordered
      ability.new(mock).grant_access_at(access_level[:sysadmin])
    end
  end

  describe "subclassing" do
    it "inherits defined levels from parent class" do
      sub1 = Class.new(klass) do
        at_level(:basic) {}
      end
      sub2 = Class.new(sub1)
      expect(sub2.levels.size).to eq(1)
    end

    it "subclass and parent class have independent levels" do
      sub1 = Class.new(klass) do
        at_level(:basic) {}
      end
      sub2 = Class.new(sub1) do
        at_level(:contribute) {}
      end
      expect(sub1.levels.size).to eq(1)
      expect(sub2.levels.size).to eq(2)
    end
  end

end
