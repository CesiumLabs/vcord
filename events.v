module valkyria

import eb
import time
import snowflake
import x.json2

pub fn(mut c Client) on(event string, handler eb.EventHandlerFn) {
	   println(event)
       match event {
		   'ready' {
			   c.events.subscribe('on_$event', handler)
		   }
		   else {}
	   }
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

pub fn(mut app ApplicationStruct) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { app.id = v.str() }
			 'flags' { app.flags = v.int() }
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

pub fn (mut r Ready) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'v' {
				r.v = v.int()
			}
			'user' {
				r.user = from_json<User>(v.as_map())
			}
			'guilds' {
				r.guilds = from_json_arr<UnavailableGuild>(v.arr())
			}
			'session_id' {
				r.session_id = v.str()
			}
			'application' {
				r.application = from_json<ApplicationStruct>(v.as_map())
			}
			else {}
		}
	}
}


