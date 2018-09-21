pragma solidity ^0.4.17;
import "./carrierBase.sol";

contract carrierCore is carrierBase{
 
 
 event Tankerisfull(uint _tankId,uint serviceId);
 event RemovedWater(uint _tankId,uint serviceReqID,string wellName,uint _carrierId);
 event ExtractedOil(uint _carrierId,uint _tankId);
 
 function tankerIsFull (uint _tankId) public returns(uint) { //api to be called based on iot input
    require(idToTank[_tankId].tankerIsfull == false);
    idToTank[_tankId].tankerIsfull = true;
    uint serviceId = _createServiceRequest(_tankId);
    emit Tankerisfull(_tankId,serviceId);  
    return serviceId;//listen to this event to get new serviceID
 }
 
 function extractWater(uint _tankId,uint _serviceReqID,string wellName,uint _carrierId) public returns(bool) { //called based on Tankerisfull event
    require(idToTank[_tankId].tankerIsfull==true);
    require(idToCarrier[_carrierId].isFree==true);
    _assigngCarrierToRequest(_serviceReqID,_carrierId);
    idToTank[_tankId].waterExtracted = true;
    idToTank[_tankId].tankerIsfull = false ;
    idToCarrier[_carrierId].isFree = false;  
    bool isExtractiondone =_extractWater(_serviceReqID,_carrierId,_tankId);
    if(isExtractiondone==true){
        idToCarrier[_carrierId].isFree==true;  
    }
    emit RemovedWater(_tankId,_serviceReqID,wellName,_carrierId); //capture servicereqID and put as solved
    return isExtractiondone;
 }
 
 function extractCrudeOil(uint _carrierId,uint _tankId) public { //called based on Removedwater event
    require(idToTank[_tankId].waterExtracted == true);
    idToTank[_tankId].waterExtracted=false;
    idToCarrier[_carrierId].isFree==false;
    emit ExtractedOil(_carrierId,_tankId);    //tanker is free now make changes to database.
    }

}