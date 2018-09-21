pragma solidity ^0.4.17;
//import "./accessControl.sol";

contract carrierBase{
    struct carrier{
    bool isFree;
    }
    struct tank 
    {
    bool tankerIsfull;
    bool waterExtracted; 
    }
    struct serviceRequest{
    bool requestComplete;
    uint requestfortankID;
    uint carrierassignedID;
    }

    carrier [] totalCarrierPool;
    tank [] listoftanks;
    serviceRequest [] allServiceRequests;
    mapping (uint => serviceRequest) idToserviceRequest;
    mapping (uint => carrier) idToCarrier;
    mapping (uint => tank) idToTank;

    event addedCarrier(uint _carrierId);
    event addedTank(uint _tankId);
    event newRequestCreated(uint _serviceReqestId);
    function addCarrieToFleet() public {

    carrier memory carrierInstance = carrier (true);
    uint _id = totalCarrierPool.push(carrierInstance) - 1;
    idToCarrier[_id] = carrierInstance;
    emit addedCarrier(_id);
    }

    function addnewTank() public  {
    tank memory tankInstance = tank(false,false);
    uint _id = listoftanks.push(tankInstance) - 1;
    idToTank[_id] = tankInstance ;
    emit addedTank(_id);
    }
    
    function _createServiceRequest(uint _tankId) internal returns (uint) {
    serviceRequest memory serviceRequestInstance = serviceRequest(false,_tankId,0);
    uint _id = allServiceRequests.push(serviceRequestInstance) - 1;
    idToserviceRequest[_id] = serviceRequestInstance ;
    //bool carrierAssigned = _assignCarrier(_id);   //deal with unassigned carrier
    return _id;
    }

    function _assigngCarrierToRequest(uint _serviceId,uint _carrierId) internal returns (bool) {
    idToserviceRequest[_serviceId].carrierassignedID=_carrierId;
    }
    function _extractWater(uint _serviceId,uint _carrierId,uint tankId) internal returns (bool) {
    idToserviceRequest[_serviceId].requestComplete=true; //need to add code based on Iot input
    return true;
    }
    
   /* function _assignCarrier(uint _serviceId) internal returns(bool) {
    for(uint i=0;i<totalCarrierPool.length;i++)
    {
     if(totalCarrierPool[i].isFree==true){
       idToserviceRequest[_serviceId].carrierId=i;
       return true;
     }
    }
    return false;
    }*/

    function tankDetails(uint _tankId) external view returns (bool,bool){
      return (idToTank[_tankId].tankerIsfull,idToTank[_tankId].waterExtracted);
    }
    function serviceDetails(uint _serviceReqId) external view returns (bool,uint,uint){
      return (idToserviceRequest[_serviceReqId].requestComplete,idToserviceRequest[_serviceReqId].requestfortankID,idToserviceRequest[_serviceReqId].carrierassignedID);
    }
    function carrierDetails(uint _carrierId) external view  returns (bool){
      return idToCarrier[_carrierId].isFree;
    }

 

}
