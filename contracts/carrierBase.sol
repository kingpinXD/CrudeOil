pragma solidity ^0.4.17;
import "./accessControl.sol";

contract carrierBase is AccessControl{
    struct carrier{
    bool isFree;
    }
    struct tank {
    bool tankerIsfull;
    bool waterExtracted; 
    }
    carrier [] totalCarrierPool;
    tank [] listoftanks;
    mapping (uint => carrier) idToCarrier;
    mapping (uint => tank) idToTank;

    event addedCarrier(uint _carrierId);
    event addedTank(uint _tankId);
    function addCarrieToFleet() public onlyCEO {

    carrier memory carrierInstance = carrier (true);
    uint _id = totalCarrierPool.push(carrierInstance) - 1;
    idToCarrier[_id] = carrierInstance;
    emit addedCarrier(_id);
    }

    function addnewTank() public onlyCEO {
    tank memory tankInstance = tank(false,false);
    uint _id = listoftanks.push(tankInstance) - 1;
    idToTank[_id] = tankInstance ;
    emit addedTank(_id);
    }

    function tankDetails(uint _tankId) external view returns (bool,bool){
      return (idToTank[_tankId].tankerIsfull,idToTank[_tankId].waterExtracted);
    }
    function carrierDetails(uint _carrierId) external view  returns (bool){
      return idToCarrier[_carrierId].isFree;
    }

 

}
