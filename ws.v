module valkyria

import time
import os 

fn (mut c Client) on_dispatch(packet &GatewayPacket) {
   event := packet.t.to_lower()
   packet_d := packet.d.as_map()
   match event {
       'ready' {
           mut data := Ready{}
           data.from_json(packet_d)
           c.events.publish('on_$event', c, data)
       }
       'message_create' {
           mut data := Message{}
              data.from_json(packet_d)
              c.events.publish('on_$event', c, data)
       }
       else {}
   }
}

fn (mut c Client) on_hello(packet &GatewayPacket) {
    mut hello := HelloPacket{}
	hello.decode(packet.d)

    c.heartbeat_interval = hello.heartbeat_interval / 1000
    c.last_heartbeat = time.now().unix
    
    identify_packet := Identify{
        token: c.token,
        properties: IdentifyProperties{
            os: os.user_os(),
            browser: 'valkyria',
            device: 'valkyria'
        },
        intents: 0
    }
    
    encoded := identify_packet.encode()
    //println(encoded)
    c.ws.write_string(encoded) or {
        println("Could not send indetification")
    }

}
