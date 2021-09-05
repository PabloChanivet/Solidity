var abi = /* abi generado por el compilador */
var ZombieFeedingContract = web3.eth.contract(abi)
var contractAddress = /* la dirección Ethereum de nuestro contrato despues de la implementación */
var ZombieFeeding = ZombieFeedingContract.at(contractAddress)

// Asumiendo que tenemos la ID de nuestro zombi y la ID del gato que queremos atacar
let zombieId = 1;
let kittyId = 1;

// Para conseguir la imagen del CryptoKitty, necesitamos hacer una consulta a su API.
// Esta información no está guardada en la blockchain, solo en su servidor web.
// Si todo se guardase en la blockchain, no nos tendríamos que preocupar
// si el servidor se cae (apaga), si cambian la API, o si la compañía 
// nos bloquea la carga de imágenes si no les gusta nuestro juego de zombis ;)
let apiUrl = "https://api.cryptokitties.co/kitties/" + kittyId
$.get(apiUrl, function(data) {
  let imgUrl = data.image_url
  // haz algo para enseñar la imagen
})

// When the user clicks on a kitty:
$(".kittyImage").click(function(e) {
  // Llama al método `feedOnKitty` de tu contrato
  ZombieFeeding.feedOnKitty(zombieId, kittyId)
})

// Escuchamos el evento del NewZombie de nuestro contrato para que podamos mostrarlo:
ZombieFactory.NewZombie(function(error, result) {
  if (error) return
  // Esta función mostrará el zombi, como en la lección 1:
  generateZombie(result.zombieId, result.name, result.dna)
})
