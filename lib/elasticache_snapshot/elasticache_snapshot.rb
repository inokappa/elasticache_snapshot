#!/usr/bin/env ruby

require 'aws-sdk'
require 'json'
require 'thor'
require 'terminal-table'

module Elasticachesnapshot
  class ORENCLI < Thor
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
      AWS::ElastiCache.new.client
    end
    
    def describe_snapshots(name=nil)
      snapshots = []
      elc.describe_snapshots[:snapshots].each do |snapshot|
        snapshot_create_time = ""
        snapshot[:node_snapshots].each do |node_snapshot|
          snapshot_create_time = node_snapshot[:snapshot_create_time]
        end
        snapshots << [ snapshot[:snapshot_name], "#{snapshot_create_time}" ]
      end
      snapshot_table = Terminal::Table.new :headings => ['SNAPSHOT Name', 'SNAPSHOT Create time'], :rows => snapshots
      puts snapshot_table
    end
    
    def elaction_snapshot_node
      cluster = []
      elc.describe_cache_clusters.cache_clusters.each do |i|
        cluster << { :cluster_id => i.cache_cluster_id, :create_time => i.cache_cluster_create_time, :cache_cluster_status => i.cache_cluster_status }
      end
    
      sorted = cluster.sort {|x, y| y[:create_time] <=> x[:create_time]}
    
      unless sorted[0][:cache_cluster_status].include?("snapshotting")
        replica_node = sorted[0][:cluster_id]
        elc.describe_replication_groups.replication_groups[0].node_groups[0].node_group_members.each do |node|
          if node.current_role == "replica" and node[:cache_cluster_id] == replica_node
            return node[:cache_cluster_id]
          end
        end
      else
        return "Error, Snapshotting..."
      end
    end
    
    def create_snapshot(snapshot_name)
      unless elaction_snapshot_node.include?("Error")
        puts "Create #{snapshot_name} from #{elaction_snapshot_node}..."
        elc.create_snapshot({ :cache_cluster_id => elaction_snapshot_node, :snapshot_name => snapshot_name })
      else
        puts elaction_snapshot_node 
      end
    end
    
    def delete_snapshot(snapshot_name)
      elc.delete_snapshot({ :snapshot_name => snapshot_name })
      puts "Deleted #{snapshot_name}"
    end
  
  end
end
