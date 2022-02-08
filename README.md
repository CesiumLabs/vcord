<p align="center">
  <img src="https://media.discordapp.net/attachments/911964535060070453/939835510329839656/Valkyria.png?width=500&height=200">
  </p>
 </br>
 
<h1>
  Example
  </h1>
  
  ```v
import valkyria


fn main() {
  mut conf := valkyria.Config{
      token: "BOT_TOKEN",
      intents: valkyria.all_intents
  }
 mut bot := valkyria.new(mut &conf) ?
  bot.on("ready", on_ready)

  bot.login() ?
}

fn on_ready(mut bot &valkyria.Bot, mut event &valkyria.Ready) {
  println("Ready")
}
```

  
