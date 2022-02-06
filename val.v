module val

import gateway
import time 

pub fn login(token string) ?&gateway.Client {
    mut c := gateway.create_connection(gateway.default_gateway, token) or {
		return error('error connecting to gateway')
	}
     mut ws := c.ws
	ws.connect() ? 
	go ws.listen()
	for true {
		time.sleep(1)
		if time.now().unix - c.last_heartbeat > c.heartbeat_interval {
			heartbeat := gateway.HeartbeatPacket {
				op: 1,
				d: c.seq
			}.encode()
			println("HEARTBEAT $heartbeat")
			c.ws.write_string(heartbeat) or {
				return error("Error")
			}
			c.last_heartbeat = time.now().unix
		}
	}
	return c
}