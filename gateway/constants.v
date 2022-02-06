module gateway

import x.json2 as json
import os

pub type Intent = i64

pub const default_gateway = "wss://gateway.discord.gg/?v=9&encoding=json"

pub const (
    guilds = Intent(1 << 0)
	guild_members = Intent(1 << 1)
	guild_bans = Intent(1 << 2)
	guild_emojis = Intent(1 << 3)
	guild_integrations = Intent(1 << 4)
	guild_webhooks = Intent(1 << 5)
	guild_invites = Intent(1 << 6)
	guild_voice_states = Intent(1 << 7)
	guild_presences = Intent(1 << 8)
	guild_messages = Intent(1 << 9)
	guild_message_reaction = Intent(1 << 10)
	guild_message_typing = Intent(1 << 11)
	direct_messages = Intent(1 << 12)
	direct_message_reactions = Intent(1 << 13)
	direct_message_typing = Intent(1 << 14)
)

pub struct GatewayPacket {
mut: 
    op int
	d json.Any
	s int
	t string
}

pub struct HelloPacket {
    mut: heartbeat_interval i64
}

pub struct HeartbeatPacket {
	op int
	d json.Any
}

pub struct Identify {
	token string
	properties IdentifyProperties = IdentifyProperties{}
	intents Intent
}

struct IdentifyProperties {
	os string = os.user_os()
	browser string = 'val'
	device string = 'val'
}

struct IdentifyPacket {
	op int
	d Identify
}

enum Op {
	dispatch
	heartbeat
	identify
	presence_update
	voice_state_update
	five_undocumented
	resume
	reconnect
	request_guild_members
	invalid_session
	hello
	heartbeat_ack
}
