# -*- coding: utf-8 -*-

module Vnet::Core
  class InterfaceRouteLinkManager < Vnet::Core::Manager
    include ActiveInterfaceEvents

    #
    # Events:
    #
    event_handler_default_drop_all

    subscribe_event INTERFACE_ROUTE_LINK_INITIALIZED, :load_item
    subscribe_event INTERFACE_ROUTE_LINK_UNLOAD_ITEM, :unload_item
    subscribe_event INTERFACE_ROUTE_LINK_CREATED_ITEM, :created_item
    subscribe_event INTERFACE_ROUTE_LINK_UPDATED_ITEM, :updated_item
    subscribe_event INTERFACE_ROUTE_LINK_DELETED_ITEM, :unload_item

    subscribe_event ACTIVATE_INTERFACE, :activate_interface
    subscribe_event DEACTIVATE_INTERFACE, :deactivate_interface

    #
    # Internal methods:
    #

    private

    #
    # Specialize Manager:
    #

    def mw_class
      MW::InterfaceRouteLink
    end

    def initialized_item_event
      INTERFACE_ROUTE_LINK_INITIALIZED
    end

    def item_unload_event
      INTERFACE_ROUTE_LINK_UNLOAD_ITEM
    end

    def match_item_proc_part(filter_part)
      filter, value = filter_part

      case filter
      when :id, :interface_id, :route_link_id
        proc { |id, item| value == item.send(filter) }
      else
        raise NotImplementedError, filter
      end
    end

    def query_filter_from_params(params)
      filter = []
      filter << {id: params[:id]} if params.has_key? :id
      filter << {interface_id: params[:interface_id]} if params.has_key? :interface_id
      filter << {route_link_id: params[:route_link_id]} if params.has_key? :route_link_id
      filter
    end

    def item_initialize(item_map)
      item_class = InterfaceRouteLinks::Base
      item_class.new(dp_info: @dp_info, map: item_map)
    end

    #
    # Create / Delete events:
    #

    # item created in db on queue 'item.id'
    def created_item(params)
      return if internal_detect_by_id(params)
      return if @active_interfaces[get_param_id(params, :interface_id)].nil?

      internal_new_item(mw_class.new(params))
    end

    def updated_item(params)
      warn log_format_h('updated_item called', params)
    end

  end
end
