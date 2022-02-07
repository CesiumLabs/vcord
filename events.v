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

pub fn (mut m Message) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' {
				m.id = v.str()
			}
			'channel_id' {
				m.channel_id = v.str()
			}
			'guild_id' {
				m.guild_id = v.str()
			}
			'author' {
				m.author = from_json<User>(v.as_map())
			}
			'member' {
				m.member = from_json<Member>(v.as_map())
			}
			'content' {
				m.content = v.str()
			}
			'timestamp' {
				m.timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'edited_timestamp' {
				m.edited_timestamp = time.parse_iso8601(v.str()) or { time.unix(0) }
			}
			'tts' {
				m.tts = v.bool()
			}
			'mention_everyone' {
				m.mention_everyone = v.bool()
			}
			'mentions' {
				m.mentions = from_json_arr<User>(v.arr())
			}
			'mention_roles' {
				mut obja := v.arr()
				for va in obja {
					m.mention_roles << va.str()
				}
			}
			'mention_channels' {
				m.mention_channels = from_json_arr<ChannelMention>(v.arr())
			}
			'attachments' {
				m.attachments = from_json_arr<Attachment>(v.arr())
			}
			'embeds' {
				m.embeds = from_json_arr<Embed>(v.arr())
			}
			'reaction' {
				m.reactions = from_json_arr<Reaction>(v.arr())
			}
			'nonce' {
				m.nonce = v.str()
			}
			'pinned' {
				m.pinned = v.bool()
			}
			'webhook_id' {
				m.webhook_id = v.str()
			}
			'type' {
				m.@type = MessageType(v.int())
			}
			'activity' {
				m.activity = from_json<MessageActivity>(v.as_map())
			}
			'application' {
				m.application = from_json<MessageApplication>(v.as_map())
			}
			'message_reference' {
				m.message_reference = from_json<MessageReference>(v.as_map())
			}
			'referenced_message' {
				mut ref := from_json<Message>(v.as_map())
				m.referenced_message = &ref
			}
			'flags' {
				m.flags = MessageFlag(byte(v.int()))
			}
			'sticker_items' {
				m.sticker_items = from_json_arr<StickerItems>(v.arr())
			}
			'interaction'{
				m.interaction = from_json<InteractionObject>(v.as_map())
			}
			'thread' {
				m.thread = from_json<Channel>(v.as_map())
			}
			'components' {
				m.components = from_json_arr<MessageComponent>(v.arr())
			}
			else {}
		}
	}
}

pub fn (mut c MessageComponent) from_json(f map[string]json2.Any) {
	for k,v in f {
		match k {
			'type' { c.@type = ComponentType(v.int()) }
            'custom_id' { c.custom_id = v.str() }
			'disabled' { c.disabled = v.bool() }
			'style' { c.style = ButtonStyle(v.int()) }
			'label' { c.label = v.str() }
			'emoji' { c.emoji = from_json<PartialEmoji>(v.as_map()) }
			'url' { c.url = v.str() }
			'options' { c.options = from_json_arr<SelectOptions>(v.arr()) }
			'placeholder' { c.placeholder = v.str() }
			'min_values' { c.min_values = v.int() }
			'max_values' { c.max_values = v.int() }
			'components' { c.components = from_json_arr<MessageComponent>(v.arr()) }
			else {}
		}
	}
}
pub fn (mut m PartialEmoji) from_json(f map[string]json2.Any) {
	for k,v in f {
		match k {
			'id' { m.id = v.str() }
			'name' { m.name = v.str() }
			'animated' { m.animated = v.bool() }
			else {}
		}
	}
}

pub fn (mut m SelectOptions) from_json(f map[string]json2.Any) {
	for k,v in f {
		match k {
			'label' { m.label = v.str() }
			'value' { m.value = v.str() }
			'description' { m.description = v.str() }
			'default' { m.default = v.bool() }
			'emoji' { m.emoji = from_json<PartialEmoji>(v.as_map())}
			else {}
		}
	}
}

pub fn (mut role Role) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { role.id = v.str() }
			'name' { role.name = v.str() }
			'color' { role.color = v.int() }
			'hoist' { role.hoist = v.bool() }
			'position' { role.position = v.int() }
			'permission' { role.permission = v.str() }
			'managed' { role.managed = v.bool() }
			'mentionable' { role.mentionable = v.bool() }
			else {}
		}
	}
}

pub fn (mut ev EmbedVideo) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'url' { ev.url = v.str() }
			'height' { ev.height = v.int() }
			'width' { ev.width = v.int() }
			else {}
		}
	}
}
pub fn (mut ep EmbedProvider) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'name' { ep.name = v.str() }
			'url' { ep.url = v.str() }
			else {}
		}
	}
}

pub fn (ep EmbedProvider) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['name'] = ep.name
	obj['url'] = ep.url
	return obj
}

pub fn (ev EmbedVideo) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['url'] = ev.url
	obj['height'] = ev.height
	obj['width'] = ev.width
	return obj
}

pub fn (mut m MessageReference) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'message_id' { m.message_id = v.str() }
			'channel_id' { m.channel_id = v.str() }
			'guild_id' { m.guild_id = v.str() }
			else {}
		}
	}
}
pub fn (mut m StickerItems) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { m.id = v.str() }
			'name' { m.name = v.str() }
			'format_type' { m.format_type = StickerFormatType(v.int()) }
			else {}
		}
	}
}

fn (mut m MessageApplication) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { m.id = v.str() }
			'cover_image' { m.cover_image = v.str() }
			'description' { m.description = v.str() }
			'icon' { m.icon = v.str() }
			'name' { m.name = v.str() }
			else {}
		}
	}
}

fn (mut m MessageActivity) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'type' { m.@type = MessageActivityType(v.int()) }
			'party_id' { m.party_id = v.str() }
			else {}
		}
	}
}

pub fn (mut cm ChannelMention) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { cm.id = v.str() }
			'guild_id' { cm.guild_id = v.str() }
			'type' { cm.@type = ChannelType(v.int()) }
			'name' { cm.name = v.str() }
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
pub fn (mut ea EmbedAuthor) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'name' { ea.name = v.str() }
			'url' { ea.url = v.str() }
			'icon_url' { ea.icon_url = v.str() }
			'proxy_icon_url' { ea.proxy_icon_url = v.str() }
			else {}
		}
	}
}

pub fn (ea EmbedAuthor) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['name'] = ea.name
	obj['url'] = ea.url
	obj['icon_url'] = ea.icon_url
	obj['proxy_icon_url'] = ea.proxy_icon_url
	return obj
}

pub fn (mut ef EmbedField) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'name' { ef.name = v.str() }
			'value' { ef.value = v.str() }
			'inline' { ef.inline = v.bool() }
			else {}
		}
	}
}

pub fn (ef EmbedField) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['name'] = ef.name
	obj['value'] = ef.value
	obj['inline'] = ef.inline
	return obj
}

pub fn (ef []EmbedField) encode() json2.Any {
	mut obj := []json2.Any{}
	for field in ef {
		obj << field.encode()
	}
	return obj
}

pub fn (mut ef EmbedFooter) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'text' { ef.text = v.str() }
			'icon_url' { ef.icon_url = v.str() }
			'proxy_icon_url' { ef.proxy_icon_url = v.str() }
			else {}
		}
	}
}

pub fn (mut ei EmbedImage) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'url' { ei.url = v.str() }
			'proxy_url' { ei.proxy_url = v.str() }
			'height' { ei.height = v.int() }
			'width' { ei.width = v.int() }
			else {}
		}
	}
}

pub fn (ei EmbedImage) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['url'] = ei.url
	obj['proxy_url'] = ei.proxy_url
	obj['height'] = ei.height
	obj['width'] = ei.width
	return obj
}

pub fn (ef EmbedFooter) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['text'] = ef.text
	obj['icon_url'] = ef.icon_url
	obj['proxy_icon_url'] = ef.proxy_icon_url
	return obj
}

pub fn (mut et EmbedThumbnail) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'url' { et.url = v.str() }
			'proxy_url' { et.proxy_url = v.str() }
			'height' { et.height = v.int() }
			'width' { et.width = v.int() }
			else {}
		}
	}
}

pub fn (et EmbedThumbnail) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['url'] = et.url
	obj['proxy_url'] = et.proxy_url
	obj['height'] = et.height
	obj['width'] = et.width
	return obj
}

pub fn (mut at Attachment) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' { at.id = v.str() }
			'filename' { at.filename = v.str() }
			'size' { at.size = v.int() }
			'url' { at.url = v.str() }
			'proxy_url' { at.proxy_url = v.str() }
			'height' { at.height = v.int() }
			'width' { at.width = v.int() }
			else {}
		}
	}
}


pub fn (mut embed Embed) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'title' {
				embed.title = v.str()
			}
			'description' {
				embed.description = v.str()
			}
			'url' {
				embed.url = v.str()
			}
			'timestamp' {
				embed.timestamp = time.parse_iso8601(v.str()) or {
					snowflake.parse_timestamp(v.str())
				}
			}
			'color' {
				embed.color = v.int()
			}
			'footer' {
				embed.footer = from_json<EmbedFooter>(v.as_map())
			}
			'image' {
				embed.image = from_json<EmbedImage>(v.as_map())
			}
			'thumbnail' {
				embed.thumbnail = from_json<EmbedThumbnail>(v.as_map())
			}
			'video' {
				embed.video = from_json<EmbedVideo>(v.as_map())
			}
			'provider' {
				embed.provider = from_json<EmbedProvider>(v.as_map())
			}
			'author' {
				embed.author = from_json<EmbedAuthor>(v.as_map())
			}
			'fields' {
				embed.image = from_json<EmbedImage>(v.as_map())
			}
			else {}
		}
	}
}

pub fn (mut embeds []Embed) from_json(f json2.Any) {
	mut obj := f.arr()
	for embed in obj {
		mut e := Embed{}
		e.from_json(embed.as_map())
		embeds << e
	}
}

pub fn (embed Embed) encode() json2.Any {
	mut obj := map[string]json2.Any{}
	obj['title'] = embed.title
	obj['description'] = embed.description
	obj['color'] = embed.color
	obj['footer'] = embed.footer.encode()
	obj['image'] = embed.image.encode()
	obj['thumbnail'] = embed.thumbnail.encode()
	obj['video'] = embed.video.encode()
	obj['provider'] = embed.provider.encode()
	obj['author'] = embed.author.encode()
	obj['fields'] = embed.fields.encode()
	return obj
}

pub fn (embed []Embed) encode() json2.Any {
	mut obj := []json2.Any{}
	for e in embed {
		obj << e.encode()
	}
	return obj
}

pub fn (embed Embed) iszero() bool {
	left := embed.encode()
	right := Embed{}
	return left.str() == right.encode().str()
}

pub fn (mut r Reaction) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'count' {
				r.count = v.int()
			}
			'me' {
				r.me = v.bool()
			}
			'emoji' {
				r.emoji = from_json<Emoji>(v.as_map())
			}
			else {}
		}
	}
}

pub fn (mut member Member) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'user' {
				member.user = from_json<User>(v.as_map())
			}
			'nick' {
				member.nick = v.str()
			}
			'roles' {
				mut roles := v.arr()
				for role in roles {
					member.roles << role.str()
				}
			}
			'joined_at' {
				member.joined_at = time.parse_iso8601(v.str()) or {
					snowflake.parse_timestamp(v.str())
				}
			}
			'premium_since' {
				member.premium_since = time.parse_iso8601(v.str()) or {
					snowflake.parse_timestamp(v.str())
				}
			}
			'deaf' {
				member.deaf = v.bool()
			}
			'mute' {
				member.mute = v.bool()
			}
			'pending' {
				member.pending = v.bool()
			}
			else {}
		}
	}
}

pub fn (mut io InteractionObject) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' {
				io.id = v.str()
			}
			'type' {
				io.@type = InteractionType(v.int())
			}
			'name' {
				io.name = v.str()
			}
			'user' {
				io.user = from_json<User>(v.as_map())
			}
			'member' {
				io.member = from_json<Member>(v.as_map())
			}
			else {}
		}
	}
}

pub fn (mut emoji Emoji) from_json(f map[string]json2.Any) {
	for k, v in f {
		match k {
			'id' {
				emoji.id = v.str()
			}
			'name' {
				emoji.name = v.str()
			}
			'roles' {
				emoji.roles = from_json_arr<Role>(v.arr())
			}
			else {}
		}
	}
}
