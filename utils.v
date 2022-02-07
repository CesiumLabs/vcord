module valkyria

import x.json2

fn from_json_arr<T>(f []json2.Any) []T {
	mut arr := []T{}
	for fs in f {
		mut item := T{}
		item.from_json(fs.as_map())
		arr << item
	}
	return arr
}

fn from_json<T>(f map[string]json2.Any) T {
	mut obj := T{}
	obj.from_json(f)
	return obj
}