# -*- coding: utf-8 -*-

Sequel.migration do
  up do

    create_table(:interface_networks) do
      primary_key :id

      Integer :interface_id, :null => false
      Integer :network_id, :null => false

      FalseClass :static, :null => false

      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      DateTime :deleted_at, :index => true
      Integer :is_deleted, :null=>false, :default=>0

      index [:interface_id, :is_deleted]
      index [:network_id, :is_deleted]

      unique [:interface_id, :network_id, :is_deleted]
    end

    create_table(:interface_segments) do
      primary_key :id

      Integer :interface_id, :null => false
      Integer :segment_id, :null => false

      FalseClass :static, :null => false

      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      DateTime :deleted_at, :index => true
      Integer :is_deleted, :null=>false, :default=>0

      index [:interface_id, :is_deleted]
      index [:segment_id, :is_deleted]

      unique [:interface_id, :segment_id, :is_deleted]
    end

    create_table(:interface_route_links) do
      primary_key :id

      Integer :interface_id, :null => false
      Integer :route_link_id, :null => false

      FalseClass :static, :null => false

      DateTime :created_at, :null=>false
      DateTime :updated_at, :null=>false
      DateTime :deleted_at, :index => true
      Integer :is_deleted, :null=>false, :default=>0

      index [:interface_id, :is_deleted]
      index [:route_link_id, :is_deleted]

      unique [:interface_id, :route_link_id, :is_deleted]
    end

  end

  down do
    drop_table(:interface_networks,
               :interface_segments,
               :interface_route_links,
               )
  end
end
