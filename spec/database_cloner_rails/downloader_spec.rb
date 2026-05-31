require "spec_helper"

RSpec.describe DatabaseClonerRails::Downloader do
  let(:dump_dir) { Dir.mktmpdir }
  subject(:downloader) { described_class.new(dump_dir: dump_dir) }

  after { FileUtils.remove_entry(dump_dir) }

  describe "#run" do
    let(:record) do
      double(to_json: '{"id":1,"name":"Alice","created_at":"2024-01-01","updated_at":"2024-01-01"}')
    end

    context "when a table has a matching model" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users"])
        stub_const("User", double("User", all: double(order: [record]), to_s: "User", present?: true))
      end

      it "creates a dump file for the table" do
        downloader.run
        expect(File.exist?(File.join(dump_dir, "users.rb"))).to be true
      end

      it "writes a create statement without id, created_at, or updated_at" do
        downloader.run
        content = File.read(File.join(dump_dir, "users.rb"))
        expect(content).to include("User.create(")
        expect(content).to include('"name"')
        expect(content).not_to include('"id"')
        expect(content).not_to include('"created_at"')
        expect(content).not_to include('"updated_at"')
      end
    end

    context "when a table has no matching model" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["schema_migrations"])
        stub_const("SchemaMigration", double("SchemaMigration", present?: false))
      end

      it "skips the table without raising" do
        expect { downloader.run }.not_to raise_error
        expect(Dir.glob(File.join(dump_dir, "*.rb"))).to be_empty
      end
    end

    context "auto-creating the dump directory" do
      let(:new_dump_dir) { File.join(Dir.mktmpdir, "nested", "dump") }
      subject(:downloader) { described_class.new(dump_dir: new_dump_dir) }

      after { FileUtils.remove_entry(File.dirname(File.dirname(new_dump_dir))) }

      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return([])
      end

      it "creates the dump directory if it does not exist" do
        expect(Dir.exist?(new_dump_dir)).to be false
        downloader.run
        expect(Dir.exist?(new_dump_dir)).to be true
      end
    end

    context "with only: filtering" do
      let(:record) do
        double(to_json: '{"id":1,"name":"Alice","created_at":"2024-01-01","updated_at":"2024-01-01"}')
      end

      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users", "posts"])
        stub_const("User", double("User", all: double(order: [record]), to_s: "User", present?: true))
        stub_const("Post", double("Post", all: double(order: [record]), to_s: "Post", present?: true))
      end

      it "only dumps tables listed in only:" do
        described_class.new(dump_dir: dump_dir, only: ["users"]).run
        expect(File.exist?(File.join(dump_dir, "users.rb"))).to be true
        expect(File.exist?(File.join(dump_dir, "posts.rb"))).to be false
      end

      it "dumps all tables when only: is nil" do
        described_class.new(dump_dir: dump_dir, only: nil).run
        expect(File.exist?(File.join(dump_dir, "users.rb"))).to be true
        expect(File.exist?(File.join(dump_dir, "posts.rb"))).to be true
      end

      it "dumps all tables when only: is empty" do
        described_class.new(dump_dir: dump_dir, only: []).run
        expect(File.exist?(File.join(dump_dir, "users.rb"))).to be true
        expect(File.exist?(File.join(dump_dir, "posts.rb"))).to be true
      end
    end
  end
end
