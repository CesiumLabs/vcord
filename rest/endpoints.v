module rest

pub fn endpoint_channels(api_url string) string {
	return "$api_url/channels"
}
pub fn endpoint_channel_message(api_url string, c_id string) string {
	return endpoint_channels(api_url) + "/$c_id/messages"
}