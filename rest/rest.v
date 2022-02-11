module rest

import net.http
pub struct Rest {
pub mut:
     token string
	 user_agent string
}

pub fn new(token string) Rest {
  mut rest := Rest{
	  token: token,
	  user_agent: 'DiscordBot (https://github.com/CesiumLabs/valkyria, v0.1.0)'
  }

  return rest
}

pub fn (mut r Rest) post(url string, data string) ? {
    mut config := http.FetchConfig{
		url: "$url",
		method: .post,
		header:  http.new_header_from_map({
			.authorization: 'Bot $r.token',
			.content_type:  'application/json',
			.user_agent:    r.user_agent
		}),
		data: data
	}

	http.fetch(config) ?
}

pub fn (mut r Rest) get(url string) ?http.Response {
	 mut config := http.FetchConfig{
		url: "$url",
		method: .get,
		header:  http.new_header_from_map({
			.authorization: 'Bot $r.token',
			.content_type:  'application/json',
			.user_agent:    r.user_agent
		})
	}

	mut resp := http.fetch(config) ?

	return resp
}