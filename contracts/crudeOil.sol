pragma solidity ^0.4.19;
// solium-disable


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
*@author Tanmay Bhattacharya
 */
/**
 * @title LicenseAccessControl
 * @notice This contract defines organizational roles and permissions.
 */
contract AccessControl {
  using SafeMath for uint;
  using SafeMath for uint256;
  /**
   * @notice ContractUpgrade is the event that will be emitted if we set a new contract address
   */
  event ContractUpgrade(address newContract);
  event Paused();
  event Unpaused();

  /**
   * @notice CEO's address FOOBAR
   */
  address public ceoAddress;

  /**
   * @notice CFO's address
   */
  address public cfoAddress;

  /**
   * @notice COO's address
   */
  address public cooAddress;

  /**
   * @notice withdrawal address
   */
  address public withdrawalAddress;

  bool public paused = false;

  /**
   * @dev Modifier to make a function only callable by the CEO
   */
  modifier onlyCEO() {
    require(msg.sender == ceoAddress);
    _;
  }

  /**
   * @dev Modifier to make a function only callable by the CFO
   */
  modifier onlyCFO() {
    require(msg.sender == cfoAddress);
    _;
  }

  /**
   * @dev Modifier to make a function only callable by the COO
   */
  modifier onlyCOO() {
    require(msg.sender == cooAddress);
    _;
  }

  /**
   * @dev Modifier to make a function only callable by C-level execs
   */
  modifier onlyCLevel() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress ||
      msg.sender == cfoAddress
    );
    _;
  }

  /**
   * @dev Modifier to make a function only callable by CEO or CFO
   */
  modifier onlyCEOOrCFO() {
    require(
      msg.sender == cfoAddress ||
      msg.sender == ceoAddress
    );
    _;
  }

  /**
   * @dev Modifier to make a function only callable by CEO or COO
   */
  modifier onlyCEOOrCOO() {
    require(
      msg.sender == cooAddress ||
      msg.sender == ceoAddress
    );
    _;
  }

  /**
   * @notice Sets a new CEO
   * @param _newCEO - the address of the new CEO
   */
  function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0));
    ceoAddress = _newCEO;
  }

  /**
   * @notice Sets a new CFO
   * @param _newCFO - the address of the new CFO
   */
  function setCFO(address _newCFO) external onlyCEO {
    require(_newCFO != address(0));
    cfoAddress = _newCFO;
  }

  /**
   * @notice Sets a new COO
   * @param _newCOO - the address of the new COO
   */
  function setCOO(address _newCOO) external onlyCEO {
    require(_newCOO != address(0));
    cooAddress = _newCOO;
  }

  /**
   * @notice Sets a new withdrawalAddress
   * @param _newWithdrawalAddress - the address where we'll send the funds
   */
  function setWithdrawalAddress(address _newWithdrawalAddress) external onlyCEO {
    require(_newWithdrawalAddress != address(0));
    withdrawalAddress = _newWithdrawalAddress;
  }

  /**
   * @notice Withdraw the balance to the withdrawalAddress
   * @dev We set a withdrawal address seperate from the CFO because this allows us to withdraw to a cold wallet.
   */
  function withdrawBalance() external onlyCEOOrCFO {
    require(withdrawalAddress != address(0));
    withdrawalAddress.transfer(address(this).balance);
  }

  /** Pausable functionality adapted from OpenZeppelin **/

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @notice called by any C-level to pause, triggers stopped state
   */
  function pause() public onlyCLevel whenNotPaused {
    paused = true;
    emit Paused();
  }

  /**
   * @notice called by the CEO to unpause, returns to normal state
   */
  function unpause() public onlyCEO whenPaused {
    paused = false;
    emit Unpaused();
  }
}


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

contract carrierCore is carrierBase{
 
 
 event Tankerisfull(uint _tankId);
 event RemovedWater(uint _tankId,string serviceReqID,string wellName,uint _carrierId);
 event ExtractedOil(uint _carrierId,uint _tankId);
 
 function tankerIsFull (uint _tankId) public { //api to be called based on iot input
    require(idToTank[_tankId].tankerIsfull == false);
    idToTank[_tankId].tankerIsfull = true;
    emit Tankerisfull(_tankId);
 }
 
 function extractWater(uint _tankId,string serviceReqID,string wellName,uint _carrierId) public { //called based on Tankerisfull event
    require(idToTank[_tankId].tankerIsfull==true);
    require(idToCarrier[_carrierId].isFree==true);
    idToTank[_tankId].waterExtracted = true;
    idToTank[_tankId].tankerIsfull = false ;
    idToCarrier[_carrierId].isFree==false;    //tanker is engaged now make changes to Database
    emit RemovedWater(_tankId,serviceReqID,wellName,_carrierId); //capture servicereqID and put as solved
 }
 
 function extractCrudeOil(uint _carrierId,uint _tankId) public { //called based on Removedwater event
    require(idToTank[_tankId].waterExtracted == true);
    idToTank[_tankId].waterExtracted=false;
    idToCarrier[_carrierId].isFree==false;
    emit ExtractedOil(_carrierId,_tankId);    //tanker is free now make changes to database.
    }

}


