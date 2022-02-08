module valkyria

import net.websocket
import time
import eb

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
    events        eb.EventBus
}

pub struct Config {
pub mut: 
    token         string   [required]
    intents       Intent   [required]
}

pub fn new(mut conf &Config) ?Bot {
    mut bot := Bot{
        token: conf.token,
        intents: conf.intents,
        ws: voidptr(0),
        events: eb.new()
    }
    create_ws(mut bot) ?

    return bot
}

pub fn (mut bot Bot) login() ? {
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