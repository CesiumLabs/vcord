module gateway

import net.websocket
import time
import x.json2 as json

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

fn (mut c Client) on_dispatch(packet GatewayPacket) {
   event := packet.t.to_lower()

   println("dispatching event: " + event)
}

fn (mut c Client) on_hello(packet GatewayPacket) {
	mut hello_packet := HelloPacket{}
	hello_packet.from_json(packet.d)

	c.heartbeat_interval = hello_packet.heartbeat_interval
    
	message := IdentifyPacket{
		d: Identify{
			token: c.token
			intents: 7
		}
	}.to_json()

	c.ws.write_string(message) or {
		return
	}

	c.last_heartbeat = time.now().unix

}

fn(mut c Client) on_heartbeat_ack(packet GatewayPacket) {
	if c.heartbeat_asked {
		return
	}

	mut heartbeat := HeartbeatPacket{
		op : 1,
		d: c.seq
}
    
	c.ws.write_string(heartbeat.to_json()) or {
		return 
	}

	c.heartbeat_asked = true
}

fn (mut p GatewayPacket) from_json(d json.Any) {
mut obj := d.as_map()
	for k, v in obj{
		match k {
			'op' {p.op = v.int()}
			's' {p.s = v.int()}
			't' {p.t = v.str()}
			'd' {p.d = v}
			else {
				println("unknown key: " + k)
			}
		}
	}
}

fn (mut p HeartbeatPacket) to_json() string {
	mut obj := map[string]json.Any
	obj['op'] = p.op
	obj['d'] = p.d
	return obj.str()
}

pub fn (mut p HelloPacket) from_json(d json.Any){
	mut obj := d.as_map()
	for k, v in obj{
		match k {
			'heartbeat_interval' {p.heartbeat_interval = i64(v.f64())}
			else{
				eprintln('there\'s an error here')
			}
		}
	}
}

pub fn (p IdentifyPacket) to_json() string{
	mut pack := map[string]json.Any
	pack['op'] = 2 // Identify op code

	mut obj := map[string]json.Any
	obj['token'] = p.d.token
	obj['intents'] = int(p.d.intents)

	mut prop := map[string]json.Any
	prop[r'$os'] = p.d.properties.os
	prop[r'$browser'] = p.d.properties.browser
	prop[r'$device'] = p.d.properties.device

	obj['properties'] = prop

	pack['d'] = obj
	return pack.str()
}






















































