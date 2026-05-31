require "spec_helper"

RSpec.describe DatabaseClonerRails::Uploader do
  subject(:uploader) { described_class.new }

  describe "#run" do
    context "when a table has a matching model" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["articles"])
        stub_const("Article", double("Article", present?: true))
      end

      it "attempts to require the dump file" do
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/articles").and_return(true)
        uploader.run
      end
    end

    context "when the dump file cannot be loaded" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["posts"])
        stub_const("Post", double("Post", present?: true))
        allow(uploader).to receive(:require).and_raise(LoadError, "cannot load")
      end

      it "prints a warning and continues" do
        expect { uploader.run }.to output(/Oops!! posts could not be uploaded/).to_stdout
      end
    end

    context "when a table has no matching model" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["schema_migrations"])
        stub_const("SchemaMigration", double("SchemaMigration", present?: false))
      end

      it "skips without attempting require" do
        expect(uploader).not_to receive(:require)
        uploader.run
      end
    end

    context "with only: filtering" do
      before do
        allow(ActiveRecord::Base).to receive_message_chain(:connection, :tables).and_return(["users", "posts"])
        stub_const("User", double("User", present?: true))
        stub_const("Post", double("Post", present?: true))
      end

      it "only uploads tables listed in only:" do
        uploader = described_class.new(only: ["users"])
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/users").and_return(true)
        expect(uploader).not_to receive(:require).with("tasks/database_cloner/db_dump/posts")
        uploader.run
      end

      it "uploads all tables when only: is nil" do
        uploader = described_class.new(only: nil)
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/users").and_return(true)
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/posts").and_return(true)
        uploader.run
      end

      it "uploads all tables when only: is empty" do
        uploader = described_class.new(only: [])
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/users").and_return(true)
        expect(uploader).to receive(:require).with("tasks/database_cloner/db_dump/posts").and_return(true)
        uploader.run
      end
    end
  end
end
