#!/usr/bin/env ruby

require 'aws-sdk'
require 'json'
require 'thor'

module Elasticachesnapshot
  class CLI < Thor
    desc "list", "Describe Snapshots"
    def list(name=nil)
      describe_snapshots
    end
  
    desc "create SNAPSHOT_NAME", "Create Snapshot SNAPSHOT_NAME"
    def create(snapshot_name= "snapshot-" + Time.now.to_i.to_s)
        create_snapshot("#{snapshot_name}")
    end
  
    desc "delete SNAPSHOT_NAME", "Dispose Snapshot SNAPSHOT_NAME"
    def delete(snapshot_name)
        delete_snapshot("#{snapshot_name}")
    end

    private 

    def elc
      AWS.config.credentials
      AWS::ElastiCache.new(region: "ap-northeast-1").client
    end
    
    def describe_snapshots(name=nil)
      elc.describe_snapshots[:snapshots].each do |snapshot|
        p snapshot[:snapshot_name]
      end
    end
    
    def elaction_snapshot_node
      cluster = []
      elc.describe_cache_clusters.cache_clusters.each do |i|
        cluster << { :cluster_id => i.cache_cluster_id, :create_time => i.cache_cluster_create_time, :cache_cluster_status => i.cache_cluster_status }
      end
    
      sorted = cluster.sort {|x, y| y[:create_time] <=> x[:create_time]}
    
      unless sorted[0][:cache_cluster_status].include?("snapshotting")
        replica_node = sorted[0][:cluster_id]
      else
        return "err, Snapshotting..."
      end
    
      elc.describe_replication_groups.replication_groups[0].node_groups[0].node_group_members.each do |node|
        if node.current_role == "replica" and node[:cache_cluster_id] == replica_node
          return node[:cache_cluster_id]
        end
      end
    end
    
    def create_snapshot(snapshot_name)
      unless elaction_snapshot_node.include?("err")
        snapshot_name = "snapshot-" + Time.now.to_i.to_s
        elc.create_snapshot({ :cache_cluster_id => elaction_snapshot_node, :snapshot_name => snapshot_name })
        p "Created #{snapshot_name}"
      end
    end
    
    def delete_snapshot(snapshot_name)
      elc.delete_snapshot({ :snapshot_name => snapshot_name })
      p "Deleted #{snapshot_name}"
    end
  
  end
end
