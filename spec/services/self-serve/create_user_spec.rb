RSpec.describe CreateUser do
  subject(:service) { described_class.new(auth: omniauth_hash) }

  let(:result) { service.call }

  let!(:user) do
    create(:user, dfe_sign_in_uid: "03f98d51-5a93-4caa-9ff2-07faff7351d2")
  end

  let(:dfe_sign_in_uid) { "03f98d51-5a93-4caa-9ff2-07faff7351d2" }

  let(:email) { "user@example.com" }

  let(:omniauth_hash) do
    {
      "uid" => dfe_sign_in_uid,
      "info" => {
        "email" => email,
      },
      "extra" => {
        "raw_info" => {
          "organisation" => {
            "id" => "23F20E54-79EA-4146-8E39-18197576F023",
          },
        },
      },
    }
  end

  let(:orgs) do
    [{
      "id" => "23F20E54-79EA-4146-8E39-18197576F023",
      "type" => { "id" => ORG_TYPE_IDS.sample.to_s },
    }]
  end

  before do
    dsi_client = instance_double(::Dsi::Client)
    allow(Dsi::Client).to receive(:new).and_return(dsi_client)
    allow(dsi_client).to receive(:orgs).and_return(orgs)
  end

  describe "#call" do
    context "when a person with that DSI UUID already exists in the database" do
      it "returns the existing user record" do
        expect(Rollbar).to receive(:info).with("Updated account for 03f98d51-5a93-4caa-9ff2-07faff7351d2").and_call_original
        expect(result).to eq user
      end
    end

    context "when a person with that DSI UUID does not exist in the database" do
      let(:dfe_sign_in_uid) { "unknown-uuid" }

      let(:email) { "unknown@example.com" }

      it "creates a new user record" do
        expect(Rollbar).to receive(:info).with("Created account for unknown-uuid").and_call_original
        expect(result).to eq User.find_by(dfe_sign_in_uid: "unknown-uuid")
      end
    end

    context "when they have updated their details" do
      let(:omniauth_hash) do
        {
          "uid" => dfe_sign_in_uid,
          "info" => {
            "first_name" => "New First",
            "last_name" => "New Last",
            "email" => email,
          },
        }
      end

      it "updates the user record" do
        expect(Rollbar).to receive(:info).with("Updated account for 03f98d51-5a93-4caa-9ff2-07faff7351d2").and_call_original

        expect(result.first_name).to eq "New First"
        expect(result.last_name).to eq "New Last"
      end
    end

    context "when the auth hash is missing the uid" do
      let(:omniauth_hash) do
        { "unexpected-key" => dfe_sign_in_uid }
      end

      it "is tagged :invalid" do
        expect(result).to be :invalid
      end
    end

    context "when the auth hash is missing" do
      let(:omniauth_hash) { nil }

      it "raises an error" do
        expect { result }.to raise_error Dry::Types::ConstraintError, /nil violates constraints/
      end
    end

    context "when they are in the ProcOps org" do
      let(:dfe_sign_in_uid) { "caseworker" }

      let(:orgs) do
        [{
          "id" => "23F20E54-79EA-4146-8E39-18197576F023",
          "name" => "DSI Caseworkers",
        }]
      end

      around do |example|
        ClimateControl.modify(PROC_OPS_TEAM: "DSI Caseworkers") do
          example.run
        end
      end

      it "creates a new user record" do
        expect(Rollbar).to receive(:info).with("Created account for caseworker").and_call_original
        expect(result).to eq User.find_by(dfe_sign_in_uid: "caseworker")
      end
    end

    context "when they are not affiliated to any organisation" do
      let(:dfe_sign_in_uid) { "no-orgs" }

      let(:orgs) { [] }

      it "is tagged :no_organisation" do
        expect(Rollbar).to receive(:info).with("User no-orgs is not in a supported organisation").and_call_original
        expect(result).to be :no_organisation
      end
    end

    context "when they are affiliated to an unsupported organisation" do
      let(:dfe_sign_in_uid) { "unsupported-org" }

      let(:orgs) do
        [{
          "id" => "23F20E54-79EA-4146-8E39-18197576F023",
          "type" => { "id" => "999" },
        }]
      end

      it "is tagged :unsupported" do
        expect(Rollbar).to receive(:info).with("User unsupported-org is not in a supported organisation").and_call_original
        expect(result).to be :unsupported
      end
    end
  end
end
