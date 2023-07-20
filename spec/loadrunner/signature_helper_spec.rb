require 'spec_helper'

describe SignatureHelper do
  describe "#verify_signature" do
    let(:payload) { { sample: 'payload' }.to_json }

    context "without GITHUB_SECRET_TOKEN" do
      context "without signature" do
        let(:signature) { nil }

        it "returns :ok" do
          expect(verify_signature payload, signature).to be :ok
        end
      end

      context "with signature" do
        let(:signature) { 'asdASD123' }

        it "returns :no_server" do
          expect(verify_signature payload, signature).to be :no_server
        end
      end
    end

    context "with GITHUB_SECRET_TOKEN" do
      before do
        ENV['GITHUB_SECRET_TOKEN'] = '123'
      end

      after do
        ENV['GITHUB_SECRET_TOKEN'] = nil
      end

      context "without signature" do
        let(:signature) { nil }

        it "returns :no_client" do
          expect(verify_signature payload, signature).to be :no_client
        end
      end

      context "with invalid signature" do
        let(:signature) { 'asdASD123' }

        it "returns :mismatch" do
          expect(verify_signature payload, signature).to be :mismatch
        end
      end

      context "with valid signature" do
        let(:signature) { generate_signature payload }

        it "returns :ok" do
          expect(verify_signature payload, signature).to be :ok
        end
      end
    end
  end
end
