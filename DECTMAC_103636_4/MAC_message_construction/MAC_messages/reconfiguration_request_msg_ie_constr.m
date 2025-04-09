%
% reconfiguration request message construction
%

% Jaakko Niemistö
% 2.4.2024


function [msg_bin] = reconfiguration_request_msg_ie_constr(...
    TX_HARQ,RX_HARQ,RD_capability,n_flows,radio_resource,...
    HARQ_process_TX,MAX_HARQ_RE_TX,...
    HARQ_process_RX,MAX_HARQ_RE_RX,...
    setup_release,flow_id)

reconfiguration_request_msg_struct.TX_HARQ = 1;
reconfiguration_request_msg_struct.RX_HARQ = 1;
reconfiguration_request_msg_struct.RD_capability = 1;
reconfiguration_request_msg_struct.n_flows = 3;
reconfiguration_request_msg_struct.radio_resource = 2;
reconfiguration_request_msg_struct.HARQ_process_TX = 3;
reconfiguration_request_msg_struct.MAX_HARQ_RE_TX = 5;
reconfiguration_request_msg_struct.HARQ_process_RX = 3;
reconfiguration_request_msg_struct.MAX_HARQ_RE_RX = 5;
reconfiguration_request_msg_struct.setup_release = 1; % array, len: n_flows
reconfiguration_request_msg_struct.flow_id = 6; % array, len: n_flows

TX_HARQ_bin = fliplr(de2bi(double(TX_HARQ),reconfiguration_request_msg_struct.TX_HARQ));
RX_HARQ_bin = fliplr(de2bi(double(RX_HARQ),reconfiguration_request_msg_struct.RX_HARQ));
RD_capability_bin = fliplr(de2bi(double(RD_capability),reconfiguration_request_msg_struct.RD_capability));
n_flows_bin = fliplr(de2bi(double(n_flows),reconfiguration_request_msg_struct.n_flows));
radio_resource_bin = fliplr(de2bi(double(radio_resource),reconfiguration_request_msg_struct.radio_resource));

msg_bin = [TX_HARQ_bin RX_HARQ_bin RD_capability_bin n_flows_bin radio_resource_bin];

if TX_HARQ == 1
    HARQ_process_TX_bin = fliplr(de2bi(double(HARQ_process_TX),reconfiguration_request_msg_struct.HARQ_process_TX));
    MAX_HARQ_RE_TX_bin = fliplr(de2bi(double(MAX_HARQ_RE_TX),reconfiguration_request_msg_struct.MAX_HARQ_RE_TX));
    msg_bin = [msg_bin HARQ_process_TX_bin MAX_HARQ_RE_TX_bin];
end

if RX_HARQ == 1
    HARQ_process_RX_bin = fliplr(de2bi(double(HARQ_process_RX),reconfiguration_request_msg_struct.HARQ_process_RX));
    MAX_HARQ_RE_RX_bin = fliplr(de2bi(double(MAX_HARQ_RE_RX),reconfiguration_request_msg_struct.MAX_HARQ_RE_RX));
    msg_bin = [msg_bin HARQ_process_RX_bin MAX_HARQ_RE_RX_bin];
end

if n_flows > 0
    for i = 1:n_flows
        setup_release_bin = fliplr(de2bi(double(setup_release(i)),reconfiguration_request_msg_struct.setup_release));
        reserved_bin  = fliplr(de2bi(double(0),1)); % reserved bits 
        flow_id_bin = fliplr(de2bi(double(flow_id(i)),reconfiguration_request_msg_struct.flow_id));
        msg_bin = [msg_bin setup_release_bin reserved_bin flow_id_bin];
    end
end

% Header type d)
ie_type = [0 0 1 1 0 1]; % reconfiguration request message type 
len = length(msg_bin);
mac_mux_pdu = mac_mux_header_d_constr(ie_type, len);

msg_bin = [mac_mux_pdu msg_bin];

end 
