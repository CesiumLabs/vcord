<p align="center">
  	<img src="https://media.discordapp.net/attachments/911964535060070453/939835510329839656/Valkyria.png?width=500&height=200">
</p>
</br>
 
# Example
  
```v
import valkyria

fn main() {
	mut conf := valkyria.Config{
		token: "BOT_TOKEN",
		intents: valkyria.all_intents
	}
	mut bot := valkyria.new(mut &conf) ?
	bot.on("ready", on_ready)
	bot.on("message_create", on_message)
	bot.login() ?
}
fn on_ready(mut bot &valkyria.Bot, mut event &valkyria.Ready) {
  	println("Ready")
}

fn on_message(mut bot &valkyria.Bot, mut message &valkyria.Message){
    if message.content == '!ping' {
        bot.create_message(message.channel_id, valkyria.MessagePayload{
            content: 'Pong!',
            embeds: [
                valkyria.MessageEmbed{
                    title: 'Hello World',
                    color: 0x7289da,
                    description: 'This is a test'
                }
            ]
        }) or {}
    }
}
```