require 'spec_helper'

describe WCC::Auth::AccessLevel do
  let(:klass) { WCC::Auth::AccessLevel }
  let(:test_db) do
    [
      { id: 1, name: "Foo", slug: "foo", description: "foo", level: 2 },
      { id: 2, name: "Bar", slug: "bar", description: "bar", level: 1 },
    ]
  end

  describe "class indexing operators" do
    subject { klass }

    it "returns record by slug if symbol or string is passed" do
      expect(klass["foo", test_db].level).to eq(2)
      expect(klass[:bar, test_db].level).to eq(1)
    end

    it "returns record by level if number is passed" do
      expect(klass[2, test_db].level).to eq(2)
      expect(klass["1", test_db].level).to eq(1)
    end

    it "uses ACCESS_LEVELS db by default" do
      expect(klass[:appadmin].slug).to eq("appadmin")
    end
  end

  describe "::all class method" do
    subject { klass }

    it "returns array of records as listed in db argument" do
      levels = subject.all(test_db)
      expect(levels.count).to eq(2)
      expect(levels.all? { |level| level.kind_of?(klass) }).to be_truthy
    end

    it "returns objects in level order" do
      levels = subject.all(test_db)
      expect(levels[0].slug).to eq("bar")
      expect(levels[1].name).to eq("Foo")
    end

    it "uses ACCESS_LEVELS constant as DB if non provided" do
      levels = subject.all
      expect(levels.count).to eq(WCC::Auth::ACCESS_LEVELS.count)
      expect(levels.last.slug).to eq("sysadmin")
    end
  end

  describe "comparability" do
    it "implements comparable methods" do
      a = klass.new
      b = klass.new
      a.level = 1
      b.level = 2
      expect(a < b).to be_truthy
      expect(b == a).to be_falsey
      expect(b < a).to be_falsey
    end
  end

end

