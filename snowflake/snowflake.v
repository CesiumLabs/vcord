module snowflake

import time

pub const (
	discord_epoch = u64(1420070400000)
)
pub struct Snowflake {
pub:
	id                  u64
	increment           u64
	internal_process_id u64
	internal_worker_id  u64
}
pub fn new_snowflake(id u64) Snowflake {
	return Snowflake{
		id: id
		increment: id & 0xFFF
		internal_process_id: (id & 0x1F000) >> 12
		internal_worker_id: (id & 0x3E0000) >> 17
	}
}
pub fn (s Snowflake) i64() i64 {
	return i64(s.id)
}
pub fn (s Snowflake) str() string {
	return s.id.str()
}
pub fn (s Snowflake) time() time.Time {
	return time.unix(int(((s.id >> 22) + snowflake.discord_epoch) / 1000))
}
pub fn (s Snowflake) is_zero() bool {
	return s.id == 0
}