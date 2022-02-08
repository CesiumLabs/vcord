module valkyria

import net.websocket
import time

struct SharedHeartbeatData {
mut:
    is_open   bool
}

pub struct Bot {
    token         string   [required]
    intents       Intent   [required]
mut:
    ws            &websocket.Client = voidptr(0)
    seq           u32
    
    hb            shared SharedHeartbeatData
    hb_thread     thread ?
    hb_last       i64
pub mut:
    latency       u32
}

pub fn run<T>(mut bot &T) ? {
    create_ws(mut bot) ?
    bot.ws.connect() ?
    bot.ws.listen() ?
}

fn (mut this Bot) hb_proc(heartbeat_interval time.Duration) ? {
    for {
        println('$heartbeat_interval')
        time.sleep(heartbeat_interval)
        println('heartbeat')
        rlock this.hb {
            if !this.hb.is_open {
                return
            }
        }
        
        if this.seq == 0 {
            this.ws.write_string('{"op":2,"d":null}') ?
        } else {
            this.ws.write_string('{"op":2,"d":$this.seq}') ?
        }
        
        this.hb_last = time.now().unix
    }
}