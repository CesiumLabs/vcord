module rest

pub fn endpoint_channels(api_url string) string {
	return "$api_url/channels"
}
pub fn endpoint_channel_message(api_url string, c_id string) string {
	return endpoint_channels(api_url) + "/$c_id/messages"
}

pub fn endpoint_channel(api_url string, c_id string) string {
	return endpoint_channels(api_url) + "/$c_id"
}

pub fn endpoint_guilds(api_url string) string {
	return "$api_url/guilds"
}

pub fn endpoint_guild(api_url string, guild_id string) string {
	return endpoint_guilds(api_url) + "/$guild_id"
}

pub fn endpoint_guild_channels(api_url string, guild_id string) string {
	return endpoint_guild(api_url, guild_id) + "/channels"
}

pub fn endpoint_channel_messages(api_url string, channel_id string) string {
	return endpoint_channel(api_url, channel_id) + "/messages"
}
pub fn endpoint_edit_channel_message(api_url string, channel_id string, message_id string) string {
	return endpoint_channel_messages(api_url, channel_id) + "/$message_id"
}