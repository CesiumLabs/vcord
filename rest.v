module vcord

import rest
import x.json2
import json

pub fn (mut bot Bot) create_message(channel_id string, data MessagePayload) ? {
        mut payload := map[string]json2.Any{}
        payload['content'] = data.content
        payload['tts'] = data.tts
        payload['embeds'] = data.embeds.to_json()
        bot.rest.post(rest.endpoint_channel_message(bot.http_endpoint, channel_id), payload.str()) ?
}

pub fn (mut bot Bot) get_channel(c_id string) ?Channel {
        mut resp := bot.rest.get(rest.endpoint_channel(bot.http_endpoint, c_id)) ?

        return json.decode(Channel, resp.text)
}

pub fn (mut bot Bot) guild_channel_create(guild_id string, data CreateChannelData) ? {
        mut payload := map[string]json2.Any{}
        payload['name'] = data.name
		if data.topic !="" {
        payload['topic'] = data.topic
		}
        payload['bitrate'] = data.bitrate | 8000
        payload['user_limit'] = data.user_limit | 0
        payload['rate_limit_per_user'] = data.rate_limit_per_user | 0
        payload['position'] = data.position | 0
		if data.parent_id != "" {
        payload['parent_id'] = data.parent_id
		}
        payload['nsfw'] = data.nsfw || false
		
       bot.rest.post(rest.endpoint_guild_channels(bot.http_endpoint, guild_id), payload.str()) ?
}