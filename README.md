<p align="center">
  	<img width="500px" height="210px" src="https://cdn.discordapp.com/attachments/855366345666854993/941699353284845578/Untitled_design.png">
</p>
</br>
 
# Example
  
```v
import vcord

fn main() {
	mut conf := vcord.Config{
		token: "BOT_TOKEN",
		intents: vcord.all_intents
	}
	mut bot := vcord.new(mut &conf) ?
	bot.on("ready", on_ready)
	bot.on("message_create", on_message)
	bot.login() ?
}
fn on_ready(mut bot &vcord.Bot, mut event &vcord.Ready) {
  	println("Ready")
}

fn on_message(mut bot &vcord.Bot, mut message &vcord.Message){
    if message.content == '!ping' {
        bot.create_message(message.channel_id, vcord.MessagePayload{
            content: 'Pong!',
            embeds: [
                vcord.MessageEmbed{
                    title: 'Hello World',
                    color: 0x7289da,
                    description: 'This is a test'
                }
            ]
        }) or {}
    }
}
```
