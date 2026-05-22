# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "db:sessions:trim_in_batches" do
  before(:all) do
    Rails.application.load_tasks
  end

  let(:task) { Rake::Task["db:sessions:trim_in_batches"] }
  let(:session_class) { ActionDispatch::Session::ActiveRecordStore.session_class }
  let(:relation) { instance_double(ActiveRecord::Relation) }

  before do
    task.reenable
    allow(Rails.logger).to receive(:info)
  end

  after do
    ENV.delete("SESSION_DAYS_TRIM_THRESHOLD")
    ENV.delete("SESSION_TRIM_BATCH_SIZE")
    ENV.delete("SESSION_TRIM_SLEEP_SECONDS")
  end

  it "deletes old sessions in batches" do
    allow(session_class).to receive(:where).and_return(relation)
    allow(relation).to receive(:limit).with(10_000).and_return(relation)

    # First batch returns a full batch, second batch returns fewer (end of data)
    allow(relation).to receive(:delete_all).and_return(10_000, 3_000)

    task.invoke

    expect(Rails.logger).to have_received(:info).with(/Session cleanup complete: 13000 rows deleted/).at_least(:once)
  end

  it "exits immediately when no sessions to delete" do
    allow(session_class).to receive(:where).and_return(relation)
    allow(relation).to receive(:limit).with(10_000).and_return(relation)
    allow(relation).to receive(:delete_all).and_return(0)

    task.invoke

    expect(Rails.logger).to have_received(:info).with(/Session cleanup complete: 0 rows deleted/).at_least(:once)
  end

  it "respects SESSION_DAYS_TRIM_THRESHOLD env var" do
    ENV["SESSION_DAYS_TRIM_THRESHOLD"] = "7"

    allow(session_class).to receive(:where) { |conditions|
      expect(conditions[:updated_at].end).to be_within(1.minute).of(7.days.ago)
      relation
    }
    allow(relation).to receive(:limit).and_return(relation)
    allow(relation).to receive(:delete_all).and_return(0)

    task.invoke
  end

  it "respects SESSION_TRIM_BATCH_SIZE env var" do
    ENV["SESSION_TRIM_BATCH_SIZE"] = "5000"

    allow(session_class).to receive(:where).and_return(relation)
    allow(relation).to receive(:limit).with(5_000).and_return(relation)
    allow(relation).to receive(:delete_all).and_return(0)

    task.invoke

    expect(relation).to have_received(:limit).with(5_000).at_least(:once)
  end

  it "respects SESSION_TRIM_SLEEP_SECONDS env var" do
    ENV["SESSION_TRIM_SLEEP_SECONDS"] = "1.0"

    allow(session_class).to receive(:where).and_return(relation)
    allow(relation).to receive(:limit).and_return(relation)
    allow(relation).to receive(:delete_all).and_return(10_000, 0)

    expect { task.invoke }.not_to raise_error
    expect(Rails.logger).to have_received(:info).with(/Session cleanup complete: 10000 rows deleted/).at_least(:once)
  end
end
