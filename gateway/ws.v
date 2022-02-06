module gateway

import net.websocket
import time
import json

pub fn create_connection(url string, token string) ?&Client {
    mut ws := websocket.new_client(url) or {
        return error("failed to create websocket client")
    }


    mut c := &Client {
        token: token,
        ws: ws,
        intents: 0
    }

    c.ws.on_open_ref(ws_on_open, c)
    c.ws.on_message_ref(ws_on_message, c)
    c.ws.on_close_ref(ws_on_close, c)
    c.ws.on_error_ref(ws_on_error, c)

    return c
}

fn (mut c Client) on_dispatch(packet &GatewayPacket) {
   event := packet.t.to_lower()

   println("dispatching event: " + event)
}

fn (mut c Client) on_hello(packet &GatewayPacket) {
    hello_data := decode_hello_packet(packet.d) or {
        println(err)
        return
    }
    
    c.heartbeat_interval = hello_data.heartbeat_interval / 1000
    c.last_heartbeat = time.now().unix
    
    identify_packet := IdentifyPacket{
        token: c.token,
        properties: IdentifyPacketProperties{
            os: 'linux',
            browser: 'valkyria',
            device: 'valkyria'
        },
        shard: [0, 1],
        guild_subscriptions: true
    }
    
    encoded := identify_packet.encode()
    //println(encoded)
    c.ws.write_string(encoded) or {
        println("Could not send indetification")
    }

}

pub fn decode_hello_packet(s string) ?HelloPacket {
    packet := json.decode(HelloPacket, s) or { return error('error') }
    return packet
}

pub fn decode_packet(s string) ?GatewayPacket {
    packet := json.decode(GatewayPacket, s) or { return error('error') }
    return packet
}

pub fn (p IdentifyPacket) encode() string {
    return json.encode(SendIdentifyPacket {
        op: u8(byte(Op.identify)),
        d:  p
    })
}

pub fn (p HeartbeatPacket) encode() string {
    return json.encode(p)
}
