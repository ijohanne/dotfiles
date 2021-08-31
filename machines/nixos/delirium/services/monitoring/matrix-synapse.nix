{ pkgs, config, secrets }:
{
  services.matrix-synapse = {
    enable_metrics = true;
    listeners = [
      {
        bind_address = "127.0.0.1";
        port = 9092;
        tls = false;
        resources = [{ names = [ "metrics" ]; compress = false; }];
      }
    ];
  };

  services.prometheus = {
    rules = [
      ''
        - name: synapse
          rules:
          - record: "synapse_federation_transaction_queue_pendingEdus:total"
            expr: "sum(synapse_federation_transaction_queue_pendingEdus or absent(synapse_federation_transaction_queue_pendingEdus)*0)"
          - record: "synapse_federation_transaction_queue_pendingPdus:total"
            expr:   "sum(synapse_federation_transaction_queue_pendingPdus or absent(synapse_federation_transaction_queue_pendingPdus)*0)"
          - record: 'synapse_http_server_request_count:method'
            labels:
              servlet: ""
            expr: "sum(synapse_http_server_request_count) by (method)"
          - record: 'synapse_http_server_request_count:servlet'
            labels:
              method: ""
            expr: 'sum(synapse_http_server_request_count) by (servlet)'

          - record: 'synapse_http_server_request_count:total'
            labels:
              servlet: ""
            expr: 'sum(synapse_http_server_request_count:by_method) by (servlet)'

          - record: 'synapse_cache:hit_ratio_5m'
            expr: 'rate(synapse_util_caches_cache:hits[5m]) / rate(synapse_util_caches_cache:total[5m])'
          - record: 'synapse_cache:hit_ratio_30s'
            expr: 'rate(synapse_util_caches_cache:hits[30s]) / rate(synapse_util_caches_cache:total[30s])'

          - record: 'synapse_federation_client_sent'
            labels:
              type: "EDU"
            expr: 'synapse_federation_client_sent_edus + 0'
          - record: 'synapse_federation_client_sent'
            labels:
              type: "PDU"
            expr: 'synapse_federation_client_sent_pdu_destinations:count + 0'
          - record: 'synapse_federation_client_sent'
            labels:
              type: "Query"
            expr: 'sum(synapse_federation_client_sent_queries) by (job)'

          - record: 'synapse_federation_server_received'
            labels:
              type: "EDU"
            expr: 'synapse_federation_server_received_edus + 0'
          - record: 'synapse_federation_server_received'
            labels:
              type: "PDU"
            expr: 'synapse_federation_server_received_pdus + 0'
          - record: 'synapse_federation_server_received'
            labels:
              type: "Query"
            expr: 'sum(synapse_federation_server_received_queries) by (job)'

          - record: 'synapse_federation_transaction_queue_pending'
            labels:
              type: "EDU"
            expr: 'synapse_federation_transaction_queue_pending_edus + 0'
          - record: 'synapse_federation_transaction_queue_pending'
            labels:
              type: "PDU"
            expr: 'synapse_federation_transaction_queue_pending_pdus + 0'

          - record: synapse_storage_events_persisted_by_source_type
            expr: sum without(type, origin_type, origin_entity) (synapse_storage_events_persisted_events_sep{origin_type="remote"})
            labels:
              type: remote
          - record: synapse_storage_events_persisted_by_source_type
            expr: sum without(type, origin_type, origin_entity) (synapse_storage_events_persisted_events_sep{origin_entity="*client*",origin_type="local"})
            labels:
              type: local
          - record: synapse_storage_events_persisted_by_source_type
            expr: sum without(type, origin_type, origin_entity) (synapse_storage_events_persisted_events_sep{origin_entity!="*client*",origin_type="local"})
            labels:
              type: bridges
          - record: synapse_storage_events_persisted_by_event_type
            expr: sum without(origin_entity, origin_type) (synapse_storage_events_persisted_events_sep)
          - record: synapse_storage_events_persisted_by_origin
            expr: sum without(type) (synapse_storage_events_persisted_events_sep)
      ''
    ];
    scrapeConfigs = [
      {
        job_name = "synapse";
        honor_labels = true;
        metrics_path = "/_synapse/metrics";
        static_configs = [{
          targets = [ "127.0.0.1:9092" ];
        }];
      }
    ];
  };
}
