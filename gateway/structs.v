module gateway

import net.websocket


pub struct Client {
	token string
	intents i64
mut: 
    ws &websocket.Client
    sid string
    seq int
    last_heartbeat i64
    heartbeat_interval i64
    heartbeat_asked bool
}
