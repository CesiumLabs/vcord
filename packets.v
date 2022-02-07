module valkyria

import x.json2 


pub fn (mut p GatewayPacket) from_json (f json2.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'op' {p.op = v.int()}
			's' {p.s = v.int()}
			't' {p.t = v.str()}
			'd' {p.d = v}
			else {}
		}
	}
}

pub fn (p Identify) encode() string{ 
	mut pack := map[string]json2.Any
	pack['op'] = 2 // Identify op code

	mut obj := map[string]json2.Any
	obj['token'] = p.token
	obj['intents'] = int(p.intents)

	mut prop := map[string]json2.Any
	prop[r'$os'] = p.properties.os
	prop[r'$browser'] = p.properties.browser
	prop[r'$device'] = p.properties.device

	obj['properties'] = prop

	pack['d'] = obj
	return pack.str()
}

pub fn (mut p HelloPacket) decode(f json2.Any){
	mut obj := f.as_map()
	for k, v in obj{
		match k {
			'heartbeat_interval' {p.heartbeat_interval = i64(v.f64())}
			else{}
		}
	}
}


pub fn (p HeartbeatPacket) encode() string {
	mut obj := map[string]json2.Any
	obj['op'] = p.op
	obj['d'] = p.d
	return obj.str()
}