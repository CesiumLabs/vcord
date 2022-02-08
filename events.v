module valkyria

// internal handler for dispatch event: 'MESSAGE_CREATE'
// data will be the raw json string of 'packet.d'
// you can serialize this to a struct through json.decode
fn (mut bot Bot) on_message_create(data string) {
    println("MESSAGE_CREATE!!!")
    println(data)
}