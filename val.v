module valkyria

import time

pub fn new_client(token string) ?&Client {
    mut c := create_connection(default_gateway, token) or {
        return error('error connecting to gateway')
    }
    
    return c
}

pub fn(mut c Client) login() ? {
     c.ws.connect() ? 
    go c.ws.listen()
    
    for {
        time.sleep(1)
        if time.now().unix - c.last_heartbeat > c.heartbeat_interval {
            heartbeat := HeartbeatPacket {
                op: 1,
                d: c.seq
            }.encode()
            println("HEARTBEAT $heartbeat")
            c.ws.write_string(heartbeat) or {
                return error('error')
            }
            c.last_heartbeat = time.now().unix
        }
    }
}