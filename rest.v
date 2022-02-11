module vcord

import rest
import x.json2 as json

pub fn (mut bot Bot) create_message(channel_id string, data MessagePayload) ? {
	mut payload := map[string]json.Any{}

	payload['content'] = data.content
	payload['tts'] = data.tts
	payload['embeds'] = data.embeds.to_json()
	 bot.rest.post(rest.endpoint_channel_message(bot.http_endpoint, channel_id), payload.str()) ?
}