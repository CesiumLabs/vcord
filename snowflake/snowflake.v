module snowflake

import time

const epoch = u64(1420070400000)

pub struct Snowflake {
pub:
	id                  u64
	increment           u64
	internal_process_id u64
	internal_worker_id  u64
	stringified			string
	timestamp			time.Time
	epoch				u64
}

pub fn deconstruct(s u64) Snowflake {
	return Snowflake{
		id: s,
		stringified: s.str(),
		increment: s & 0xFFF,
		epoch: epoch,
		internal_process_id: (s & 0x1F000) >> 12,
		internal_worker_id: (s & 0x3E0000) >> 17,
		timestamp: time.unix(int(((s >> 22) + epoch) / 1000))
	}
}

pub fn generate(timestamp i64, increment int) u64 {
	mut snowflake_increment := u64(increment)

	if snowflake_increment >= 4095 {
		snowflake_increment = 0
	} else {
		snowflake_increment += 1
		if snowflake_increment >= 4095 {
			snowflake_increment = 0
		}
	}

	return u64(((u64(timestamp * 1000) - epoch) << 22) | ((snowflake_increment & 0b11111) << 17) | ((1 & 0b11111) << 12) | 0)
}

pub fn generate_random(increment int) u64 {
	return generate(time.now().unix, increment)
}