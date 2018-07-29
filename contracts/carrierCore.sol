pragma solidity ^0.4.17;
import "./carrierBase.sol";

contract carrierCore is carrierBase{
 
 
 event Tankerisfull(uint _tankId);
 event RemovedWater(string serviceReqID,string carrierName,string fieldName,string wellName,string _wellApiNum,uint _carrierId,uint _lat,uint _long,uint _levelFeet,uint _lebelInches);
 event ExtractedOil(uint _carrierId,uint _tankId);
 
 function tankerIsFull (uint _tankId) public { //api to be called based on iot input
    require(idToTank[_tankId].tankerIsfull == false);
    idToTank[_tankId].tankerIsfull = true;
    emit Tankerisfull(_tankId);
 }
 
 function extractWater(uint _tankId,string serviceReqID,string carrierName,string fieldName,string wellName,string _wellApiNum,uint _carrierId,uint _lat,uint _long,uint _levelFeet,uint _lebelInches) public { //called based on Tankerisfull event
    require(idToTank[_tankId].tankerIsfull==true);
    require(idToCarrier[_carrierId].isFree==true);
    idToTank[_tankId].waterExtracted = true;
    idToTank[_tankId].tankerIsfull = false ;
    idToCarrier[_carrierId].isFree==false;    //tanker is engaged now make changes to Database
    emit RemovedWater(serviceReqID,carrierName,fieldName,wellName,_wellApiNum,_carrierId, _lat,_long,_levelFeet,_lebelInches); //capture servicereqID and put as solved
 }
 
 function extractCrudeOil(uint _carrierId,uint _tankId) public { //called based on Removedwater event
    require(idToTank[_tankId].waterExtracted == true);
    idToTank[_tankId].waterExtracted=false;
    idToCarrier[_carrierId].isFree==false;
    emit ExtractedOil(_carrierId,_tankId);    //tanker is free now make changes to database.
    }

}