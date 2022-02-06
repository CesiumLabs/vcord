module valkyria

import eb
import net.websocket
import time
import os
import x.json2 as json

pub struct GatewayPacket {
mut: 
    op   int
    d    json.Any
    s    int
    t    string
}

pub struct HelloPacket {
mut:
    heartbeat_interval i64
}

pub struct HeartbeatPacket {
    op   json.Any
    d    int
}

struct Identify {
	token string
	properties IdentifyProperties
	intents Intent
}

struct IdentifyProperties {
	os string = os.user_os()
	browser string = 'valkyria'
	device string = 'valkyria'
}


struct SendIdentifyPacket {
    op  u8
    d   Identify
}

pub struct Client {
    token      string
    intents    Intent
pub mut:  
    ws                 &websocket.Client
    sid                string
    seq                int
    last_heartbeat     i64
    heartbeat_interval i64
    heartbeat_asked    bool
    events     &eb.EventBus
}

pub struct Ready {
pub mut:
	v                int
	user             User
	private_channels []Channel
	guilds           []UnavailableGuild
	session_id       string
	shard            [2]int
}

pub struct UnavailableGuild {
pub mut:
	id          string
	unavailable bool
}

pub struct User {
pub mut:
	id            string
	username      string
	discriminator string
	avatar        Avatar
	bot           bool
	system        bool
	mfa_enabled   bool
	locale        string
	verified      bool
	email         string
	flags         UserFlag
	premium_type  PremiumType
	public_flags  UserFlag
}

pub type UserFlag = int

pub enum PremiumType {
	@none
	nitro_classic
	nitro
}

pub struct Channel {
pub mut:
	id                    string
	@type                 ChannelType
	guild_id              string
	position              int
	permission_overwrites PermissionOverwrite
	name                  string
	topic                 string
	nsfw                  bool
	last_message_id       string
	bitrate               int
	user_limit            int
	rate_limit_per_user   int
	recipients            []User
	icon                  string
	owner_id              string
	application_id        string
	parent_id             string
	last_pin_timestamp    time.Time
}

enum ChannelType {
	guild_text
	dm
	guild_voice
	group_dm
	guild_category
	guild_news
	guild_store
}

enum PermissionOverwriteType {
	role
	user
}

struct PermissionOverwrite {
pub mut:
	id    string
	@type PermissionOverwriteType
	allow string
	deny  string
}

pub struct Avatar {
	user_id string
pub:
	hash string
}