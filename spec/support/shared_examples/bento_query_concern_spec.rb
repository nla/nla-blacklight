# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "BentoQueryConcern" do |klass|
  describe "#start_request" do
    it "adds a CachedThreadPool to the context" do
      subject.start_request

      expect(subject.instance_variables).to include(:@context)

      context = subject.instance_variable_get :@context
      expect(context).to include(:pool)

      pool = context[:pool]
      expect(pool).not_to be_nil
      expect(pool.running?).to be true

      subject.finish_request
    end

    it "shuts down the thread pool at the end of a request" do
      subject.start_request
      subject.finish_request

      expect(subject.instance_variables).to include(:@context)

      context = subject.instance_variable_get :@context
      expect(context[:pool].running?).to be false
      expect(context[:pool].shutdown?).to be true
    end
  end
end
