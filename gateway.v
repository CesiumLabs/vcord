module valkyria

import net.websocket
import eb
import x.json2 as json

pub fn create_connection(url string, token string) ?&Client {
    mut ws := websocket.new_client(url) or {
        return error("failed to create websocket client")
    }


    mut c := &Client {
        token: token,
        ws: ws,
        intents: 0,
        events: eb.new()
    }

    c.ws.on_open_ref(ws_on_open, c)
    c.ws.on_message_ref(ws_on_message, c)
    c.ws.on_close_ref(ws_on_close, c)
    c.ws.on_error_ref(ws_on_error, c)

    return c
}

fn ws_on_open(mut ws websocket.Client, mut c &Client) ? {
    println("Sucessfully connected to the gateway")
}

fn ws_on_error(mut ws websocket.Client, error string, mut c &Client) ? {
    println("Error: " + error)
}

fn ws_on_close(mut ws websocket.Client, code int, reason string, mut c &Client) ? {
    println('Disconnected from the gateway reason: $reason & code: $code')
}

fn ws_on_message(mut ws websocket.Client, msg &websocket.Message, mut c &Client) ? {
    match msg.opcode {
        .text_frame {
           packet := json.decode<GatewayPacket>(string(msg.payload)) ?
            c.seq = packet.s
            
            match Op(packet.op) {
                .dispatch { c.on_dispatch(&packet) }
                .hello { println("$packet.op") c.on_hello(&packet) }
                else {
                    println("$packet.op")
                }
            }
        }
        
        else {}
    } 
}