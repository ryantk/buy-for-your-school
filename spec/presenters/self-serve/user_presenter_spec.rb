RSpec.describe UserPresenter do
  subject(:presenter) { described_class.new(user) }

  describe "#full_name" do
    context "when a full name exists" do
      let(:user) { build(:user, full_name: "Ms Phoebe Buffay", first_name: "Phoebe", last_name: "Buffay") }

      it "returns the full name" do
        expect(presenter.full_name).to eq "Ms Phoebe Buffay"
      end
    end

    context "when a full name does not exist" do
      let(:user) { build(:user, full_name: nil, first_name: "Phoebe", last_name: "Buffay") }

      it "concatenates the first and last names" do
        expect(presenter.full_name).to eq "Phoebe Buffay"
      end
    end
  end

  describe "#active_journeys" do
    let(:user) { build(:user, journeys: [build(:journey), build(:journey)]) }

    it "decorates the journeys" do
      expect(presenter.active_journeys).to be_kind_of(Array)
      expect(presenter.active_journeys.all? { |j| j.instance_of?(JourneyPresenter) }).to be true
    end
  end
end
