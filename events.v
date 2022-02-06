module valkyria

pub fn (mut c Client) on_ready(handler fn(mut Client, &Ready)) {
	c.events.subscribe('on_ready', handler)
}