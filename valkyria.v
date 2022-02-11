module valkyria

import net.websocket
import net.http
import time
import eb
import x.json2 as json

struct SharedHeartbeatData {
mut:
	is_open bool
}

pub struct Bot {
	token   string [required]
	intents Intent [required]
mut:
	ws  &websocket.Client = voidptr(0)
	seq u32

	hb        shared SharedHeartbeatData
	hb_thread thread ?
	hb_last   i64

	http_endpoint string

	user_agent string
pub mut:
	latency u32
	events  eb.EventBus
}

pub struct Config {
pub mut:
	token   string [required]
	intents Intent [required]
}

pub fn new(mut conf Config) ?Bot {
	mut bot := Bot{
		token: conf.token
		intents: conf.intents
		ws: voidptr(0)
		events: eb.new()
		http_endpoint: 'https://discord.com/api/v9'
		user_agent: 'DiscordBot (https://github.com/CesiumLabs/valkyria, v0.1.0)'
	}
	create_ws(mut bot) ?

	return bot
}

pub fn (mut bot Bot) login() ? {
	bot.ws.connect() ?
	bot.ws.listen() ?
}

pub struct MessagePayload {
pub mut:
	content string
	embeds  []MessageEmbed
	tts     bool
}

pub fn (mut bot Bot) create_message(channel_id string, data MessagePayload) ? {
	mut payload := map[string]json.Any{}

	payload['content'] = data.content
	payload['tts'] = data.tts
	payload['embeds'] = data.embeds.to_json()

	// TODO: implement api router
	http.fetch(http.FetchConfig{
		url: '$bot.http_endpoint/channels/$channel_id/messages'
		method: .post
		header: http.new_header_from_map({
			.authorization: 'Bot $bot.token'
			.content_type:  'application/json'
			.user_agent:    bot.user_agent
		})
		data: payload.str()
	}) ?
}

fn (mut this Bot) hb_proc(heartbeat_interval time.Duration) ? {
	for {
		println('$heartbeat_interval')
		time.sleep(heartbeat_interval)
		println('heartbeat')
		rlock this.hb {
			if !this.hb.is_open {
				return
			}
		}

		if this.seq == 0 {
			this.ws.write_string('{"op":2,"d":null}') ?
		} else {
			this.ws.write_string('{"op":2,"d":$this.seq}') ?
		}

		this.hb_last = time.now().unix
	}
}
