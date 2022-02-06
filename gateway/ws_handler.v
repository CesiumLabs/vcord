module gateway

import net.websocket
import json

fn ws_on_open(mut ws websocket.Client, mut c &Client) ? {
	println("Sucessfully connected to the gateway")
}

fn ws_on_error(mut ws websocket.Client, error string, mut c &Client) ? {
	println("Error: " + error)
}

fn ws_on_close(mut ws websocket.Client, code int, reason string, mut c &Client) ? {
	println('Disconnected from the gateway reason: $reason & code: $code')
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut c &Client) ? {
	match msg.opcode {
		.text_frame {
			packet := json.decode(GatewayPacket, msg.payload.bytestr()) or {
				return error("Failed to decode packet")
			}
			c.seq = packet.s
			match Op(packet.op) {
			.dispatch { c.on_dispatch(packet) }
		   .heartbeat_ack { c.on_heartbeat_ack(packet) }
		   .hello { c.on_hello(packet) }
		   else {
			return error("unknown opcode")
		   }
			}
		}
		else {
			return error("unkown opcode")
		}
	} 
}