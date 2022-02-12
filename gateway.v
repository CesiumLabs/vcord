module vcord

import net.websocket
import json
import os { user_os }
import time

const default_gateway = 'wss://gateway.discord.gg/?v=9&encoding=json'

struct GatewayPacket {
	op byte   [required]
	d  string [raw]
	s  u32    [required]
	t  string
}

struct HelloPacket {
	heartbeat_interval u32 [required]
}

struct Resume {
	token string  [required]
	session_id string [required]
	seq       int    [required]
}
struct Identify {
	token      string             [required]
	properties IdentifyProperties [required]
	intents    Intent             [required]
}

struct IdentifyProperties {
	os      string [json: '\$os']
	browser string [json: '\$browser']
	device  string [json: '\$device']
}

fn gateway_respond(mut ws websocket.Client, op byte, data string) ? {
	ws.write_string('{"op":$op,"d":$data}') ?
}

pub fn create_ws(mut bot &Bot) ? {
	bot.ws = websocket.new_client(default_gateway) ?
	bot.ws.on_message_ref(ws_on_message, bot)
	bot.ws.on_close_ref(ws_on_close, bot)
}

fn ws_on_close(mut ws websocket.Client, reason int, message string, mut bot &Bot) ? {
	lock bot.hb {
		if bot.hb.is_open {
			bot.hb.is_open = false
			bot.hb_thread.wait() ?
		}
	}
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut bot &Bot) ? {
	if msg.opcode != .text_frame {
		return
	}

	payload_string := msg.payload.bytestr()
	packet := json.decode(GatewayPacket, payload_string) ?

	if packet.s != 0 {
		bot.seq = packet.s
	}

	match Op(packet.op) {
		.dispatch {
			event_func_name := 'on_$packet.t.to_lower()'

			// also dispatch as raw event
			handle_events(mut bot, 'on_raw', payload_string) ?
			handle_events(mut bot, event_func_name, packet.d) ?
		}
		.hello {
			hello := json.decode(HelloPacket, packet.d) ?
           if bot.resuming == true {
			   mut resume := Resume {
				   token: bot.token,
				   session_id: bot.sid,
				   seq: bot.seq
			   }

			   gateway_respond(mut &ws, 6, json.encode(resume)) ?
		   }
			identify_packet := Identify{
				token: bot.token
				properties: IdentifyProperties{
					os: user_os()
					browser: 'valkyria'
					device: 'valkyria'
				}
				intents: bot.intents
			}

			gateway_respond(mut &ws, 2, json.encode(identify_packet)) ?

			lock bot.hb {
				bot.hb.is_open = true
			}

			bot.hb_thread = go bot.hb_proc(hello.heartbeat_interval * time.millisecond)
		}
		.heartbeat_ack {
			if bot.hb_last != 0 {
				bot.latency = u32(time.now().unix - bot.hb_last)
			}
		}

		.reconnect {
			bot.resuming = true
			bot.ws.close(1000, 'Reconnect') ?
		}
		else {}
	}
}
