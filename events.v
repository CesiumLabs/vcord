module valkyria

import eb
import json

fn handle_events(mut bot Bot, event_func_name string, packet string) ? {
	match event_func_name { 
		'on_ready' {
			mut data := json.decode(Ready, packet) ?
      		bot.events.publish(event_func_name, bot, data)
		}
		'on_message_create' {
			mut data := json.decode(Message, packet) ?
			bot.events.publish(event_func_name, bot, data)
		}
		else{}
	}
}

pub fn (mut bot Bot) on (event string, handler eb.EventHandlerFn) {
	  bot.events.subscribe('on_$event', handler)
}

