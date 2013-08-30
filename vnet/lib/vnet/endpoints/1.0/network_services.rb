# -*- coding: utf-8 -*-

Vnet::Endpoints::V10::VnetAPI.namespace '/network_services' do

  post do
    params = parse_params(@params, ["uuid", "vif_uuid", "display_name",
      "incoming_port", "outgoing_port"])
    required_params(params, ["display_name"])
    check_and_trim_uuid(M::NetworkService, params)
    check_syntax_and_get_id(M::Vif, params, "vif_uuid", "vif_id")

    network_service = M::NetworkService.create(params)
    respond_with(R::NetworkService.generate(network_service))
  end

  get do
    network_services = M::NetworkService.all
    respond_with(R::NetworkServiceCollection.generate(network_services))
  end

  get '/:uuid' do
    network_service = check_syntax_and_pop_uuid(M::NetworkService, @params)
    respond_with(R::NetworkService.generate(network_service))
  end

  delete '/:uuid' do
    network_service = check_syntax_and_pop_uuid(M::NetworkService, @params)
    network_service.batch.destroy.commit
    respond_with(R::NetworkService.generate(network_service))
  end

  put '/:uuid' do
    params = parse_params(@params, ["uuid", "vif_uuid", "display_name",
      "incoming_port", "outgoing_port"])
    network_service = check_syntax_and_pop_uuid(M::NetworkService, params)
    network_service.batch.update(params).commit
    updated_nws = M::NetworkService[@params["uuid"]]
    respond_with(R::NetworkService.generate(updated_nws))
  end
end
