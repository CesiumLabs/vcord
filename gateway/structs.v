module gateway

import net.websocket


pub struct Client {
	token string
	intents i64

pub mut:  
    ws &websocket.Client
    sid string
    seq int
    last_heartbeat i64
    heartbeat_interval i64
    heartbeat_asked bool
}

pub struct GatewayPacket {
mut: 
    op int
	d string
	s int
	t string
}

pub struct HelloPacket {
    mut: heartbeat_interval i64
}

pub struct HeartbeatPacket {
	op int
	d int
}

struct IdentifyPacketProperties {
	os		string [json:"\$os"] = os.user_os()
	browser string [json:"\$browser"]
	device	string [json:"\$device"]
}
struct IdentifyPacket {
	token 				string
	properties 			IdentifyPacketProperties
	compress			bool
	large_threshold		int = 250
	shard				[]int = [0, 1]
	guild_subscriptions	bool = true
}
struct SendIdentifyPacket {
	op 	int
	d	IdentifyPacket
}