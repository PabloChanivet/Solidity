pragma solidity ^0.4.25;

contract ZombieFactory {

    //Defino un evento que emitiré cada vez que se cree un nuevo zombie, y que tendrá como parámetros el id del zombie (posición
    //en el array), un nombre y un ADN
    event NewZombie(uint zombieId, string name, uint dna);

    //El ADN del zombie tendrá 16 dígitos
    uint dnaDigits = 16;
    //Para asegurarnos de que el número tendrá 16 dígitos
    //Ojo, son variables de estado, que estarán definidas en nuestro contrato en la blockchain
    uint dnaModulus = 10 ** dnaDigits;

    //Creo un struct para definir el "objeto" tipo Zombie, que tendrá un nombre y un adn
    struct Zombie {
        string name;
        uint dna;
    }

    //Defino nuestro array de zombies como una variable de estado que estará definida en nuestro contrato en la blockchain
    Zombie[] public zombies;
    
    //Para hacer el juego multijugador, necesito asociar el zombie a un usuario (dirección). Para ello voy a usar dos mappings:
    //El primer mapping será público (accesible desde cualquier contrato) y 
    //tendrá como clave un uint, y como valor una dirección. Lo usaré para saber que zombie tiene cada dirección/usuario
    mapping (uint => address) public zombieToOwner;
    //El segundo tendrá una dirección como clave y un uint como valor. Lo usaré para saber cuantos zombies tiene cada dirección/usuario.
    mapping (address => uint) ownerZombieCount;

    //Creo una función privada que genera un nuevo objeto Zombie a partir de un nombre y un ADN, y lo añade al array de Zombies.
    //Emito un evento de tipo NewZombie cada vez que se crea un nuevo zombie para que el frontend pueda detectar su creación.
    //Añado la actualización de los mapping para asignarle propiedad a un zombie. Para ello usaré la variable global msg.sender que ya nos proporciona
    //solidity, que identifica la dirección de quien está llamando a la función publica createRandomZombie. Primero utilizo el mapping zombieToOwner para 
    //asignar al id del zombie la dirección del usuario, y después incremento el valor (contador) del mapping ownerZombieCount para esa dirección.
    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;        
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    //Creo otra función privada de tipo view (ya que solo va a acceder a las variables de estado del contrato, pero no las va a editar)
    //para generar un número aleatorio de 16 dígitos a partir de la función hash definida en solidity keccak256, basada en SHA3.
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    //Creo una función pública (que podrá ser accedida por otros contratos de la blockchain) que se encargará de generar los zombies a partir
    //de un nombre introducido por el usuario
    //Implemento una limitación (para ello uso require) para que solamente los nuevos usuarios puedan llamar a esta función para crear el primer zombie, ya que no queremos
    //que un usuario pueda crear un ejército infinito de zombies.
    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender]==0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

//Para evitar que el contrato se haga enorme, voy a usar herencia para crear un nuevo contrato que herede del anterior

contract ZombieFeeding is ZombieFactory {

}
