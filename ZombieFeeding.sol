pragma solidity ^0.4.25;

//Para evitar que el contrato se haga enorme, voy a usar herencia para crear un nuevo contrato que herede del anterior. 
//Para ello tengo que importar el contrato del que hereda
import "./zombieContract.sol";

//Nuestros zombies se van a alimentar de cryptoKitties. Para ello nuestra dApp va a utilizar el contrato de cryptoKitties ya existente en la blockchain,
//y para hacerlo necesitamos definir una interfaz. La interfaz va a definir la función getKitty de cryptoKitties, que devuelve entre otras cosas los genes
//del kitty, que es lo que necesitamos para generar un nuevo zombie.
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
  
  //Vamos a crear una función pública (se puede llamar desde otros contratos) para que un zombie se alimente de otras formas de vida.
  //Cuando esto pase el ADN del zombie se combinará con el ADN de la víctima, creando un nuevo zombie (la víctima se convierte en zombie).
  //Como no queremos que cualquier persona se alimente usando nuestro zombie, tenemos que comprobar que el zombie pertenece a quien está llamando
  //a la función. Para ello uso la cláusula require, asegurándome de que el msg.sender es igual al dueño del zombie.
  //Como necesito saber el ADN del zombie, necesito obtener un puntero al zombie, que está en mi array de zombies en la blockchain. Lo guardaré en
  //una variable local de tipo Zombie que es un puntero al zombie concreto del array de zombies, que se guardará en la blockchain (es decir, de tipo storage)
  //El ADN del zombie resultante lo calcularemos como el promedio entre el ADN del zombie y el ADN de la víctima, asegurándonos que el ADN de la víctima (_targetDNA)
  //tiene 16 dígitos (para ello nos quedamos con los últimos 16 dígitos usando la división módulo 16)
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {
    require(msg.sender == zombieToOwner[_zombieId]);
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna ) / 2;
    _createZombie("NoName", newDna);
  }

}
