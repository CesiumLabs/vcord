<p align="center">
  <img src="https://media.discordapp.net/attachments/911964535060070453/939835510329839656/Valkyria.png?width=500&height=200">
  </p>
 </br>
 
<h1>
  Example
  </h1>
  
  ```v
import valkyria as val


fn main() {
    mut c := val.new_client("BOT_TOKEN") or {
        exit(1)
    }
    
    c.on_ready(on_ready)

    c.login() ?
}

 fn on_ready(mut c val.Client, r &val.Ready) {
    println("Ready!")
}
```

  
