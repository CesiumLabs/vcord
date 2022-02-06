module val

import gateway

pub fn login(token string) ?&gateway.Client {
    mut c := gateway.create_connection(gateway.default_gateway, token) or {
		return error("Could not connect to gateway")
	}

	return c
}