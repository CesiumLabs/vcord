module valkyria

import net.websocket
import time
import x.json2
import os 
import snowflake

fn (mut c Client) on_dispatch(packet &GatewayPacket) {
   event := packet.t.to_lower()
   packet_d := packet.d.as_map()
   match event {
       'ready' {
           mut data := Ready{}
           data.from_json(packet_d)
           c.events.publish('on_$event', c, data)
       }
       else {}
   }
}

fn (mut c Client) on_hello(packet &GatewayPacket) {
    mut hello := HelloPacket{}
	hello.decode(packet.d)

    c.heartbeat_interval = hello.heartbeat_interval / 1000
    c.last_heartbeat = time.now().unix
    
    identify_packet := Identify{
        token: c.token,
        properties: IdentifyProperties{
            os: os.user_os(),
            browser: 'valkyria',
            device: 'valkyria'
        },
        intents: 0
    }
    
    encoded := identify_packet.encode()
    //println(encoded)
    c.ws.write_string(encoded) or {
        println("Could not send indetification")
    }

}

pub fn (mut r Ready) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'v' {
				r.v = v.int()
			}
			'user' {
				r.user = from_json<User>(v.as_map())
			}
			'private_channels' {
				r.private_channels = from_json_arr<Channel>(v.arr())
			}
			'guilds' {
				r.guilds = from_json_arr<UnavailableGuild>(v.arr())
			}
			'session_id' {
				r.session_id = v.str()
			}
			else {}
		}
	}
}

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

pub fn (mut channel Channel) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' {
				channel.id = v.str()
			}
			'type' {
				channel.@type = ChannelType(v.int())
			}
			'guild_id' {
				channel.guild_id = v.str()
			}
			'position' {
				channel.position = v.int()
			}
			'permission_overwrites' {
				channel.permission_overwrites = from_json<PermissionOverwrite>(v.as_map())
			}
			'name' {
				channel.name = v.str()
			}
			'topic' {
				channel.topic = v.str()
			}
			'nsfw' {
				channel.nsfw = v.bool()
			}
			'last_message_id' {
				channel.last_message_id = v.str()
			}
			'bitrate' {
				channel.bitrate = v.int()
			}
			'user_limit' {
				channel.user_limit = v.int()
			}
			'rate_limit_per_user' {
				channel.rate_limit_per_user = v.int()
			}
			'recipients' {
				channel.recipients = from_json_arr<User>(v.arr())
			}
			'icon' {
				channel.icon = v.str()
			}
			'owner_id' {
				channel.owner_id = v.str()
			}
			'application_id' {
				channel.application_id = v.str()
			}
			'parent_id' {
				channel.parent_id = v.str()
			}
			'last_pin_timestamp' {
				channel.last_pin_timestamp = time.parse_iso8601(v.str()) or {
					snowflake.parse_timestamp(v.str())
				}
			}
			else {}
		}
	}
}

pub fn (mut user User) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { user.id = v.str() }
			'username' { user.username = v.str() }
			'discriminator' { user.discriminator = v.str() }
			'bot' { user.bot = v.bool() }
			'system' { user.system = v.bool() }
			'mfa_enabled' { user.mfa_enabled = v.bool() }
			'locale' { user.locale = v.str() }
			'verified' { user.verified = v.bool() }
			'email' { user.email = v.str() }
			'flags' { user.flags = UserFlag(v.int()) }
			'premium_type' { user.premium_type = PremiumType(v.int()) }
			'public_flags' { user.public_flags = UserFlag(v.int()) }
			else {}
		}
	}
	if avatar := f['avatar'] {
		hash := avatar.str()
		user.avatar = Avatar{
			user_id: user.id
			hash: hash
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

fn from_json_arr<T>(f []json2.Any) []T {
	mut arr := []T{}
	for fs in f {
		mut item := T{}
		item.from_json(fs.as_map())
		arr << item
	}
	return arr
}

fn from_json<T>(f map[string]json2.Any) T {
	mut obj := T{}
	obj.from_json(f)
	return obj
}

fn (mut g UnavailableGuild) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { g.id = v.str() }
			'unavailable' { g.unavailable = v.bool() }
			else {}
		}
	}
}

pub fn (mut po PermissionOverwrite) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { po.id = v.str() }
			'type' { po.@type = PermissionOverwriteType(v.int()) }
			'allow' { po.allow = v.str() }
			'deny' { po.deny = v.str() }
			else {}
		}
	}
}
