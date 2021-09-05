pragma solidity ^0.4.25;

//Para evitar que el contrato se haga enorme, voy a usar herencia para crear un nuevo contrato que herede del anterior. 
//Para ello tengo que importar el contrato del que hereda
import "./zombieContract.sol";

contract ZombieFeeding is ZombieFactory {

}
