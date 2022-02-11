module rest

pub fn endpoint_channels(api_url string) string {
	return "$api_url/channels"
}
pub fn endpoint_channel_message(api_url string, cID string) string {
	return endpoint_channels(api_url) + "/$cID/messages"
}