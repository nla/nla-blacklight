require "rails_helper"
require "blacklight/solr/cloud/repository"

RSpec.describe Blacklight::Solr::Cloud::Repository do
  subject(:repository) { described_class.new blacklight_config }

  before do
    delete_with_children(zk_in_solr, "/live_nodes")
    delete_with_children(zk_in_solr, "/collections")
    wait_until(10) do
      !zk_in_solr.exists?("/live_nodes")
    end
    wait_until(10) do
      !zk_in_solr.exists?("/collections")
    end
    zk_in_solr.create("/live_nodes")
    zk_in_solr.create("/collections")

    %w[192.168.1.21:8983_solr 192.168.1.22:8983_solr 192.168.1.23:8983_solr 192.168.1.24:8983_solr].each do |node|
      zk_in_solr.create("/live_nodes/#{node}", "", mode: :ephemeral)
    end

    zk_in_solr.create("/collections/collection1")
    json = File.read("spec/files/collection1_all_nodes_alive.json")
    zk_in_solr.create("/collections/collection1/state.json",
      json,
      mode: :ephemeral)

    ENV["ZK_HOST"] = "localhost:2181"
    ENV["SOLR_COLLECTION"] = "collection1"
  end

  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }

  let(:zk_in_solr) { ZK.new }

  after do
    zk_in_solr&.close
  end

  it "retrieves all the urls and leader node urls from zookeeper" do
    expect(repository.instance_variable_get(:@leader_urls).sort).to eq(
      %w[http://192.168.1.22:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect(repository.instance_variable_get(:@all_urls).sort).to eq(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.22:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
  end

  it "configures the RSolr client with one of the active nodes in the select request" do
    client = repository.connection
    uri = client.instance_variable_get(:@uri)
    expect(uri.host).to be_one_of(%w[192.168.1.21 192.168.1.22 192.168.1.23 192.168.1.24])
    expect(uri.path).to eq("/solr/collection1/")
  end

  it "raises an exception when no nodes are available" do
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_all_nodes_down.json"))
    expect { repository.connection }.to raise_error(Blacklight::Solr::Cloud::NotEnoughNodes)
  end

  it "removes downed replica node and adds recovered node" do
    zk_in_solr.delete("/live_nodes/192.168.1.21:8983_solr")
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_replica_down.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.22:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.22:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )

    zk_in_solr.create("/live_nodes/192.168.1.21:8983_solr", mode: :ephemeral)
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_all_nodes_alive.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.22:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.22:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
  end

  it "removes a downed leader and adds recovered node" do
    zk_in_solr.delete("/live_nodes/192.168.1.22:8983_solr")
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_leader_down.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )

    zk_in_solr.create("/live_nodes/192.168.1.22:8983_solr", mode: :ephemeral)
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_all_nodes_alive.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.22:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.22:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
  end

  it "removes recovering leader node and adds recovered node" do
    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_leader_recovering.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )

    zk_in_solr.set("/collections/collection1/state.json", File.read("spec/files/collection1_all_nodes_alive.json"))
    expect { repository.instance_variable_get(:@leader_urls).sort }.to become_soon(
      %w[http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
    expect { repository.instance_variable_get(:@all_urls).sort }.to become_soon(
      %w[http://192.168.1.21:8983/solr/collection1 http://192.168.1.22:8983/solr/collection1 http://192.168.1.23:8983/solr/collection1 http://192.168.1.24:8983/solr/collection1].sort
    )
  end
end
