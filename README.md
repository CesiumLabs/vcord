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
    mut bot := valkyria.Bot{
        token: "asdasjdfsdfsdhfudf",
        intents: valkyria.all_intents
    }
    
    valkyria.run<valkyria.Bot>(mut &bot) ?
}
```

  
